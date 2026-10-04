import { createFileRoute } from "@tanstack/react-router";
import { useSuspenseQuery } from "@tanstack/react-query";
import { Suspense } from "react";
import { statsQuery, topicsQuery } from "@/lib/data";
import { Empty, GridSkeleton, PageError, SectionHead, StatCard, TopicCard } from "@/components/context-ui";

export const Route = createFileRoute("/")({
  head: () => ({
    meta: [
      { title: "Context — Understand the story, not just the headline" },
      { name: "description", content: "Numbers, timelines, perspectives and sources behind India's biggest news stories." },
      { property: "og:title", content: "Context — Understand the story, not just the headline" },
      { property: "og:description", content: "Numbers, timelines, perspectives and sources behind India's biggest news stories." },
    ],
  }),
  loader: ({ context }) => {
    context.queryClient.prefetchQuery(statsQuery({ featured: true }));
    context.queryClient.prefetchQuery(topicsQuery());
  },
  component: Home,
  errorComponent: ({ error }) => <PageError error={error} />,
});

function Home() {
  return (
    <main className="mx-auto max-w-6xl px-4 sm:px-6">
      <section className="py-16 sm:py-24">
        <div className="eyebrow mb-4">News, with the context left in</div>
        <h1 className="max-w-4xl text-5xl font-semibold leading-[1.05] sm:text-7xl">
          Understand the story. <em className="font-normal text-primary">Not just the headline.</em>
        </h1>
        <p className="mt-6 max-w-2xl text-lg text-muted-foreground">
          See the numbers, context, timeline, perspectives and sources behind the news.
        </p>
      </section>

      <section className="mb-16">
        <SectionHead eyebrow="India at a glance" title="Key numbers" />
        <Suspense fallback={<GridSkeleton />}><KeyNumbers /></Suspense>
      </section>

      <Suspense fallback={<GridSkeleton n={6} h="h-56" />}><Topics /></Suspense>
    </main>
  );
}

function KeyNumbers() {
  const { data } = useSuspenseQuery(statsQuery({ featured: true }));
  if (!data.length) return <Empty text="No statistics available yet." />;
  return <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">{data.map((s) => <StatCard key={s.id} s={s} />)}</div>;
}

function Topics() {
  const { data } = useSuspenseQuery(topicsQuery());
  const trending = data.slice(0, 6);
  const missing = [...data].sort((a, b) => a.trend_score - b.trend_score).slice(0, 3);
  return (
    <>
      <section className="mb-16">
        <SectionHead eyebrow="Most followed" title="Trending now" />
        {trending.length ? (
          <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">{trending.map((t) => <TopicCard key={t.id} t={t} />)}</div>
        ) : <Empty text="No topics yet." />}
      </section>
      <section className="rounded-xl bg-foreground p-6 text-background sm:p-10">
        <div className="mb-6 flex flex-col gap-2 sm:flex-row sm:items-end sm:justify-between">
          <div>
            <div className="eyebrow !text-background/60">Getting less attention</div>
            <h2 className="text-3xl font-semibold">You may be missing</h2>
          </div>
          <p className="font-display text-2xl italic text-background/80">Popular ≠ complete.</p>
        </div>
        <div className="grid gap-4 text-foreground md:grid-cols-3">{missing.map((t) => <TopicCard key={t.id} t={t} variant="quiet" />)}</div>
      </section>
    </>
  );
}
