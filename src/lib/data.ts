import { queryOptions } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import type { Tables } from "@/integrations/supabase/types";

export type Topic = Tables<"topics">;
export type Article = Tables<"articles">;
export type Perspective = Tables<"perspectives">;
export type TimelineEvent = Tables<"timeline_events">;
export type Statistic = Tables<"statistics">;
export type TopicWithCount = Topic & { source_count: number };

export const CATEGORIES = [
  { slug: "politics", name: "Politics", blurb: "Elections, policy and how power is exercised — seen from more than one side." },
  { slug: "economy", name: "Economy", blurb: "Growth, prices and interest rates, with the official numbers and what they leave out." },
  { slug: "crime", name: "Crime", blurb: "Reported cases, rates and convictions — clearly separated, because they measure different things." },
  { slug: "sports", name: "Sports", blurb: "The results, and the structures behind them." },
  { slug: "technology", name: "Technology", blurb: "Digital policy, AI and data — who gains, who carries the risk." },
] as const;
export type CategorySlug = (typeof CATEGORIES)[number]["slug"];
export const findCategory = (slug: string) => CATEGORIES.find((c) => c.slug === slug);

async function withCounts(topics: Topic[]): Promise<TopicWithCount[]> {
  if (!topics.length) return [];
  const { data, error } = await supabase.from("articles").select("topic_id").in("topic_id", topics.map((t) => t.id));
  if (error) throw error;
  return topics.map((t) => ({ ...t, source_count: data.filter((a) => a.topic_id === t.id).length }));
}

export const topicsQuery = (category?: string) =>
  queryOptions({
    queryKey: ["topics", category ?? "all"],
    queryFn: async () => {
      let q = supabase.from("topics").select("*").order("trend_score", { ascending: false });
      if (category) q = q.eq("category", category);
      const { data, error } = await q;
      if (error) throw error;
      return withCounts(data);
    },
  });

export const statsQuery = (opts: { category?: string; featured?: boolean }) =>
  queryOptions({
    queryKey: ["stats", opts.category ?? "all", !!opts.featured],
    queryFn: async () => {
      let q = supabase.from("statistics").select("*").order("sort_order");
      if (opts.category) q = q.eq("category", opts.category);
      if (opts.featured) q = q.eq("featured", true);
      const { data, error } = await q;
      if (error) throw error;
      return data;
    },
  });

export const topicDetailQuery = (id: string) =>
  queryOptions({
    queryKey: ["topic", id],
    queryFn: async () => {
      const [t, a, p, e] = await Promise.all([
        supabase.from("topics").select("*").eq("id", id).maybeSingle(),
        supabase.from("articles").select("*").eq("topic_id", id).order("published_at", { ascending: false }),
        supabase.from("perspectives").select("*").eq("topic_id", id).order("created_at"),
        supabase.from("timeline_events").select("*").eq("topic_id", id).order("event_date"),
      ]);
      for (const r of [t, a, p, e]) if (r.error) throw r.error;
      return { topic: t.data, articles: a.data ?? [], perspectives: p.data ?? [], timeline: e.data ?? [] };
    },
  });

export const fmtDate = (d: string | null | undefined) =>
  d ? new Date(d).toLocaleDateString("en-IN", { day: "numeric", month: "short", year: "numeric" }) : "";
export const isUuid = (s: string) => /^[0-9a-f-]{36}$/i.test(s);
