import { createFileRoute, notFound, Link } from "@tanstack/react-router";
import { useSuspenseQuery } from "@tanstack/react-query";
import { Suspense } from "react";
import { ArrowLeft } from "lucide-react";
import { findCategory, statsQuery, topicsQuery } from "@/lib/data";
import { Empty, GridSkeleton, PageError, SectionHead, StatCard, TopicCard } from "@/components/context-ui";

export const Route = createFileRoute("/$category")({
  loader: ({ params, context }) => {
    const cat = findCategory(params.category);
    if (!cat) throw notFound();
    context.queryClient.prefetchQuery(statsQuery({ category: cat.name }));
    context.queryClient.prefetchQuery(topicsQuery(cat.name));
    return { name: cat.name, blurb: cat.blurb };
  },
  head: ({ loaderData }) => {
    const title = loaderData ? `${loaderData.name} — Context` : "Not found — Context";
    const desc = loaderData?.blurb ?? "Category not found.";
    return { meta: [{ title }, { name: "description", content: desc }, { property: "og:title", content: title }, { property: "og:description", content: desc }] };
  },
  component: CategoryPage,
  errorComponent: PageError,
  notFoundComponent: () => (
    <div className="mx-auto max-w-xl px-4 py-24 text-center">
      <h1 className="text-3xl font-semibold">No such section</h1>
      <Link to="/" className="mt-4 inline-block text-primary underline">Back home</Link>
    </div>
  ),
});

function CategoryPage() {
  const { name, blurb } = Route.useLoaderData();
  return (
    <main className="mx-auto max-w-6xl px-4 sm:px-6">
      <Link to="/" className="mt-8 inline-flex items-center gap-1 text-sm text-muted-foreground hover:text-foreground"><ArrowLeft className="h-4 w-4" /> Home</Link>
      <header className="py-10 sm:py-14">
        <div className="eyebrow mb-3">Section</div>
        <h1 className="text-5xl font-semibold sm:text-6xl">{name}</h1>
        <p className="mt-4 max-w-2xl text-lg text-muted-foreground">{blurb}</p>
      </header>
      <section className="mb-16">
        <SectionHead eyebrow="Every figure shows its source and date" title="Key statistics" />
        <Suspense fallback={<GridSkeleton />}><Stats name={name} /></Suspense>
      </section>
      <section>
        <SectionHead eyebrow={`In ${name}`} title="Trending topics" />
        <Suspense fallback={<GridSkeleton n={3} h="h-56" />}><Topics name={name} /></Suspense>
      </section>
    </main>
  );
}

function Stats({ name }: { name: string }) {
  const { data } = useSuspenseQuery(statsQuery({ category: name }));
  if (!data.length) return <Empty text="No statistics for this section yet." />;
  return (
    <>
      <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">{data.map((s) => <StatCard key={s.id} s={s} />)}</div>
      {name === "Crime" && (
        <p className="mt-4 max-w-3xl text-sm text-muted-foreground">
          Reported cases count registrations, not total incidents. A rise can reflect easier reporting as well as more crime. Rates adjust for population; conviction rates measure court outcomes.
        </p>
      )}
    </>
  );
}

function Topics({ name }: { name: string }) {
  const { data } = useSuspenseQuery(topicsQuery(name));
  if (!data.length) return <Empty text="No topics in this section yet." />;
  return <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">{data.map((t) => <TopicCard key={t.id} t={t} />)}</div>;
}
