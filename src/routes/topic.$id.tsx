import { createFileRoute, Link, notFound } from "@tanstack/react-router";
import { useSuspenseQuery } from "@tanstack/react-query";
import { Suspense, useEffect, useState } from "react";
import { ArrowLeft, ArrowUpRight, CheckCircle2, HelpCircle, MessageSquareQuote, Sparkles, X } from "lucide-react";
import { findCategory, fmtDate, isUuid, topicDetailQuery, topicsQuery, type Perspective, type Topic } from "@/lib/data";
import { Empty, PageError, SectionHead, Skeleton, TopicCard } from "@/components/context-ui";

export const Route = createFileRoute("/topic/$id")({
  loader: async ({ params, context }) => {
    if (!isUuid(params.id)) throw notFound();
    const d = await context.queryClient.ensureQueryData(topicDetailQuery(params.id));
    if (!d.topic) throw notFound();
    context.queryClient.prefetchQuery(topicsQuery());
    return { title: d.topic.title, summary: d.topic.summary };
  },
  head: ({ loaderData }) => {
    if (!loaderData) return { meta: [{ title: "Topic unavailable — Context" }, { name: "robots", content: "noindex" }] };
    const title = `${loaderData.title} — Context`;
    const desc = loaderData.summary.slice(0, 155);
    return { meta: [{ title }, { name: "description", content: desc }, { property: "og:title", content: title }, { property: "og:description", content: desc }, { property: "og:type", content: "article" }] };
  },
  component: TopicPage,
  pendingComponent: () => <div className="mx-auto max-w-4xl space-y-4 px-4 py-16"><Skeleton className="h-10 w-2/3" /><Skeleton className="h-32" /><Skeleton className="h-64" /></div>,
  errorComponent: PageError,
  notFoundComponent: () => (
    <div className="mx-auto max-w-xl px-4 py-24 text-center">
      <h1 className="text-3xl font-semibold">Topic not found</h1>
      <Link to="/" className="mt-4 inline-block text-primary underline">Back home</Link>
    </div>
  ),
});

const NAV = [["what", "What happened"], ["facts", "Key facts"], ["perspectives", "Perspectives"], ["timeline", "Timeline"], ["sources", "Sources"], ["debate", "Established vs debated"], ["why", "Why it matters"]];

function TopicPage() {
  const { id } = Route.useParams();
  const { data } = useSuspenseQuery(topicDetailQuery(id));
  const { topic, articles, perspectives, timeline } = data;
  const [aiOpen, setAiOpen] = useState(false);
  if (!topic) return null;
  const cat = CATEGORY(topic.category);
  const sentences = topic.summary.split(/(?<=\.)\s+/);

  return (
    <main className="mx-auto max-w-6xl px-4 sm:px-6">
      <div className="mt-8 flex gap-4 text-sm text-muted-foreground">
        <Link to="/" className="inline-flex items-center gap-1 hover:text-foreground"><ArrowLeft className="h-4 w-4" /> Home</Link>
        {cat && <Link to="/$category" params={{ category: cat.slug }} className="hover:text-foreground">/ {cat.name}</Link>}
      </div>

      <header className="grid gap-8 py-10 lg:grid-cols-[1fr_auto] lg:items-end">
        <div>
          <span className="inline-block rounded bg-accent px-2 py-1 font-mono text-xs uppercase tracking-wider text-accent-foreground">{topic.category}</span>
          <h1 className="mt-4 max-w-4xl text-4xl font-semibold leading-tight sm:text-6xl">{topic.title}</h1>
          <p className="mt-4 text-sm text-muted-foreground">Updated {fmtDate(topic.published_at)} · {articles.length} sources · {perspectives.length} perspectives · Demo data</p>
        </div>
        <button onClick={() => setAiOpen(true)} className="inline-flex items-center gap-2 self-start rounded-full bg-foreground px-5 py-3 text-sm font-medium text-background transition-opacity hover:opacity-90 lg:self-end">
          <Sparkles className="h-4 w-4" /> AI Overview
        </button>
      </header>

      <div className="grid gap-12 lg:grid-cols-[180px_1fr]">
        <aside className="hidden lg:block">
          <nav className="sticky top-24 space-y-2 text-sm">
            {NAV.map(([k, l]) => <a key={k} href={`#${k}`} className="block text-muted-foreground hover:text-foreground">{l}</a>)}
          </nav>
        </aside>

        <div className="min-w-0 space-y-16">
          <section id="what" className="scroll-mt-24">
            <SectionHead eyebrow="01" title="What happened?" />
            <p className="font-display text-xl leading-relaxed sm:text-2xl">{sentences[0]}</p>
            <p className="mt-4 text-lg leading-relaxed text-muted-foreground">{sentences.slice(1).join(" ")}</p>
          </section>

          <section id="facts" className="scroll-mt-24">
            <SectionHead eyebrow="02" title="Key facts" />
            <ol className="grid gap-3 sm:grid-cols-2">
              {topic.key_facts.map((f, i) => (
                <li key={i} className="flex gap-3 rounded-lg border bg-card p-4">
                  <span className="font-mono text-sm text-primary">{String(i + 1).padStart(2, "0")}</span>
                  <span className="text-sm leading-relaxed">{f}</span>
                </li>
              ))}
            </ol>
          </section>

          <section id="perspectives" className="scroll-mt-24">
            <SectionHead eyebrow="03" title="Different perspectives" />
            <Perspectives items={perspectives} />
          </section>

          <section id="timeline" className="scroll-mt-24">
            <SectionHead eyebrow="04" title="How we got here" />
            {timeline.length ? (
              <ol className="relative border-l-2 border-foreground/80 pl-8">
                {timeline.map((e, i) => (
                  <li key={e.id} className="relative pb-8 last:pb-0">
                    <span className={`absolute -left-[41px] top-1 h-4 w-4 rounded-full border-2 border-foreground ${i === timeline.length - 1 ? "bg-primary" : "bg-background"}`} />
                    <div className="font-mono text-xs uppercase tracking-wider text-muted-foreground">{fmtDate(e.event_date)}</div>
                    <h3 className="mt-1 text-xl font-semibold">{e.title}</h3>
                    {e.description && <p className="mt-1 text-sm text-muted-foreground">{e.description}</p>}
                    {e.source_name && (
                      <a href={e.source_url ?? "#"} target="_blank" rel="noreferrer" className="mt-2 inline-flex items-center gap-1 text-xs text-primary hover:underline">
                        {e.source_name} <ArrowUpRight className="h-3 w-3" />
                      </a>
                    )}
                  </li>
                ))}
              </ol>
            ) : <Empty text="No timeline events yet." />}
          </section>

          <section id="sources" className="scroll-mt-24">
            <SectionHead eyebrow="05" title="Coverage & sources" />
            {articles.length ? (
              <div className="grid gap-3 sm:grid-cols-2">
                {articles.map((a) => {
                  const demo = a.source_url?.includes("example.com");
                  return (
                    <article key={a.id} className="flex flex-col rounded-lg border bg-card p-4">
                      <div className="flex flex-wrap items-center gap-2 text-xs">
                        <span className="font-semibold">{a.source_name}</span>
                        <span className="rounded bg-secondary px-1.5 py-0.5 font-mono uppercase text-muted-foreground">{a.source_type}</span>
                        {demo && <span className="rounded border px-1.5 py-0.5 font-mono uppercase text-muted-foreground">Demo</span>}
                      </div>
                      <h3 className="mt-2 text-lg font-semibold leading-snug">{a.title}</h3>
                      {a.summary && <p className="mt-1 text-sm text-muted-foreground">{a.summary}</p>}
                      <div className="mt-auto flex items-center justify-between pt-4 text-xs text-muted-foreground">
                        <span>{fmtDate(a.published_at)}{a.perspective && <> · {a.perspective}</>}</span>
                        <a href={a.source_url ?? "#"} target="_blank" rel="noreferrer" className="inline-flex items-center gap-1 font-medium text-primary hover:underline">Read source <ArrowUpRight className="h-3 w-3" /></a>
                      </div>
                    </article>
                  );
                })}
              </div>
            ) : <Empty text="No sources linked yet." />}
          </section>

          <section id="debate" className="scroll-mt-24">
            <SectionHead eyebrow="06" title="What is established vs debated?" />
            <div className="grid gap-4 md:grid-cols-3">
              <DebateCol icon={<CheckCircle2 className="h-4 w-4" />} label="Established" tone="text-established" border="border-t-established" items={topic.established} />
              <DebateCol icon={<MessageSquareQuote className="h-4 w-4" />} label="Claimed" tone="text-claimed" border="border-t-claimed" items={topic.claimed} />
              <DebateCol icon={<HelpCircle className="h-4 w-4" />} label="Disputed / uncertain" tone="text-disputed" border="border-t-disputed" items={topic.disputed} />
            </div>
          </section>

          <section id="why" className="scroll-mt-24">
            <SectionHead eyebrow="07" title="Why it matters" />
            <ul className="space-y-3">
              {topic.why_it_matters.map((w, i) => (
                <li key={i} className="flex gap-3 text-lg"><span className="mt-3 h-1.5 w-1.5 shrink-0 rounded-full bg-primary" />{w}</li>
              ))}
            </ul>
          </section>

          <section>
            <SectionHead eyebrow="Fill the gaps" title="You may be missing" />
            <Suspense fallback={<Skeleton className="h-48" />}><Related topic={topic} /></Suspense>
          </section>
        </div>
      </div>

      {aiOpen && <AiOverview topic={topic} perspectives={perspectives} onClose={() => setAiOpen(false)} />}
    </main>
  );
}

const CATEGORY = (name: string) => findCategory(name.toLowerCase());

function Perspectives({ items }: { items: Perspective[] }) {
  const [active, setActive] = useState(0);
  if (!items.length) return <Empty text="No perspectives recorded yet." />;
  const p = items[active] ?? items[0];
  return (
    <div>
      <div className="mb-4 flex flex-wrap gap-2">
        {items.map((x, i) => (
          <button key={x.id} onClick={() => setActive(i)} className={`rounded-full border px-3 py-1.5 text-sm transition-colors ${i === active ? "border-foreground bg-foreground text-background" : "bg-card hover:border-foreground/40"}`}>
            {x.perspective_name}
          </button>
        ))}
      </div>
      <div className="rounded-lg border bg-card p-6 sm:p-8">
        <div className="eyebrow">{p.perspective_name}</div>
        <h3 className="mt-2 text-2xl font-semibold">{p.title}</h3>
        <p className="mt-3 text-lg leading-relaxed">{p.content}</p>
        <div className="mt-6 grid gap-4 border-t pt-4 text-sm sm:grid-cols-2">
          {p.evidence && <div><div className="eyebrow mb-1">Evidence cited</div>{p.evidence}</div>}
          {p.source_name && <div><div className="eyebrow mb-1">Source</div>{p.source_name}</div>}
        </div>
      </div>
      <p className="mt-3 text-xs text-muted-foreground">Perspectives are summarised, not ranked. Where evidence clearly supports one claim, that is reflected in "Established" below.</p>
    </div>
  );
}

function DebateCol({ icon, label, tone, border, items }: { icon: React.ReactNode; label: string; tone: string; border: string; items: string[] }) {
  return (
    <div className={`rounded-lg border border-t-4 bg-card p-5 ${border}`}>
      <div className={`flex items-center gap-2 text-sm font-semibold ${tone}`}>{icon}{label}</div>
      {items.length ? (
        <ul className="mt-3 space-y-2 text-sm leading-relaxed">{items.map((x, i) => <li key={i}>{x}</li>)}</ul>
      ) : <p className="mt-3 text-sm text-muted-foreground">Nothing recorded.</p>}
    </div>
  );
}

function Related({ topic }: { topic: Topic }) {
  const { data } = useSuspenseQuery(topicsQuery());
  const others = data.filter((t) => t.id !== topic.id);
  const rel = [...others.filter((t) => t.category === topic.category), ...others.filter((t) => t.category !== topic.category).sort((a, b) => a.trend_score - b.trend_score)].slice(0, 3);
  if (!rel.length) return <Empty text="No related topics yet." />;
  return <div className="grid gap-4 md:grid-cols-3">{rel.map((t) => <TopicCard key={t.id} t={t} variant="quiet" />)}</div>;
}

function AiOverview({ topic, perspectives, onClose }: { topic: Topic; perspectives: Perspective[]; onClose: () => void }) {
  const [loading, setLoading] = useState(true);
  useEffect(() => {
    const t = setTimeout(() => setLoading(false), 900);
    const k = (e: KeyboardEvent) => e.key === "Escape" && onClose();
    window.addEventListener("keydown", k);
    return () => { clearTimeout(t); window.removeEventListener("keydown", k); };
  }, [onClose]);
  const find = (re: RegExp) => perspectives.find((p) => re.test(p.perspective_name));
  const gov = find(/government|official/i);
  const crit = find(/opposition|critical|industry/i);
  const ind = find(/independent|expert|international/i);
  const blocks: [string, React.ReactNode][] = [
    ["What happened", topic.summary.split(/(?<=\.)\s+/).slice(0, 2).join(" ")],
    ["Key established facts", <ul className="list-disc space-y-1 pl-5">{topic.established.map((x, i) => <li key={i}>{x}</li>)}</ul>],
    ["Government / official position", gov?.content ?? "No official position recorded."],
    ["Critical / opposing perspective", crit?.content ?? "No critical perspective recorded."],
    ["Independent / expert perspective", ind?.content ?? "No independent perspective recorded."],
    ["What remains uncertain", <ul className="list-disc space-y-1 pl-5">{topic.disputed.map((x, i) => <li key={i}>{x}</li>)}</ul>],
  ];
  return (
    <div className="fixed inset-0 z-50 flex items-end justify-center bg-foreground/40 p-0 sm:items-center sm:p-6" onClick={onClose}>
      <div role="dialog" aria-label="AI Context Overview" className="max-h-[90vh] w-full max-w-2xl overflow-y-auto rounded-t-xl bg-background p-6 shadow-2xl sm:rounded-xl sm:p-8" onClick={(e) => e.stopPropagation()}>
        <div className="flex items-start justify-between gap-4">
          <div>
            <div className="eyebrow flex items-center gap-1.5"><Sparkles className="h-3.5 w-3.5 text-primary" /> Generated from sourced data</div>
            <h2 className="mt-1 text-3xl font-semibold">AI Context Overview</h2>
          </div>
          <button onClick={onClose} aria-label="Close" className="rounded-full p-2 hover:bg-secondary"><X className="h-5 w-5" /></button>
        </div>
        {loading ? (
          <div className="mt-6 space-y-3">{[1, 2, 3, 4].map((i) => <Skeleton key={i} className="h-16" />)}</div>
        ) : (
          <ol className="mt-6 space-y-5">
            {blocks.map(([h, b], i) => (
              <li key={h} className="border-t pt-4">
                <div className="flex gap-3">
                  <span className="font-mono text-sm text-primary">{i + 1}</span>
                  <div className="min-w-0">
                    <h3 className="font-sans text-sm font-semibold uppercase tracking-wide">{h}</h3>
                    <div className="mt-1 text-sm leading-relaxed text-muted-foreground">{b}</div>
                  </div>
                </div>
              </li>
            ))}
          </ol>
        )}
        <p className="mt-6 rounded-lg bg-secondary p-3 text-xs text-muted-foreground">This overview summarises information and disagreement. It does not judge which side is correct.</p>
      </div>
    </div>
  );
}
