import { Link } from "@tanstack/react-router";
import { ArrowDownRight, ArrowRight, ArrowUpRight, Minus, TrendingUp, Newspaper } from "lucide-react";
import type { Statistic, TopicWithCount } from "@/lib/data";
import { CATEGORIES, fmtDate } from "@/lib/data";

export function SiteHeader() {
  return (
    <header className="sticky top-0 z-40 border-b bg-background/90 backdrop-blur">
      <div className="mx-auto flex max-w-6xl items-center gap-6 px-4 py-3 sm:px-6">
        <Link to="/" className="font-display text-2xl font-semibold tracking-tight">
          Context<span className="text-primary">.</span>
        </Link>
        <nav className="-mx-2 flex flex-1 gap-1 overflow-x-auto text-sm">
          <Link to="/" activeOptions={{ exact: true }} className="rounded px-2 py-1 text-muted-foreground hover:text-foreground" activeProps={{ className: "!text-foreground font-medium" }}>Home</Link>
          {CATEGORIES.map((c) => (
            <Link key={c.slug} to="/$category" params={{ category: c.slug }} className="whitespace-nowrap rounded px-2 py-1 text-muted-foreground hover:text-foreground" activeProps={{ className: "!text-foreground font-medium" }}>
              {c.name}
            </Link>
          ))}
        </nav>
        <span className="eyebrow hidden md:inline">Demo data</span>
      </div>
    </header>
  );
}

export function SiteFooter() {
  return (
    <footer className="mt-24 border-t">
      <div className="mx-auto flex max-w-6xl flex-col gap-2 px-4 py-8 text-sm text-muted-foreground sm:flex-row sm:justify-between sm:px-6">
        <span className="font-display text-base text-foreground">Context.</span>
        <span>Prototype · curated demo data · sources marked "Demo" are placeholders.</span>
      </div>
    </footer>
  );
}

export function SectionHead({ eyebrow, title, aside }: { eyebrow?: string; title: string; aside?: React.ReactNode }) {
  return (
    <div className="rule-top mb-6 flex items-end justify-between gap-4 pt-3">
      <div>
        {eyebrow && <div className="eyebrow mb-1">{eyebrow}</div>}
        <h2 className="text-2xl font-semibold sm:text-3xl">{title}</h2>
      </div>
      {aside}
    </div>
  );
}

export function StatCard({ s }: { s: Statistic }) {
  const Icon = s.change_direction === "up" ? ArrowUpRight : s.change_direction === "down" ? ArrowDownRight : Minus;
  return (
    <div className="flex flex-col rounded-lg border bg-card p-5">
      <div className="flex items-start justify-between gap-2">
        <span className="text-sm font-medium">{s.name}</span>
        {s.metric_type && <span className="rounded bg-secondary px-1.5 py-0.5 font-mono text-[10px] uppercase tracking-wide text-muted-foreground">{s.metric_type}</span>}
      </div>
      <div className="mt-3 flex items-baseline gap-1.5">
        <span className="font-display text-4xl font-semibold">{s.value}</span>
        <span className="text-sm text-muted-foreground">{s.unit}</span>
      </div>
      {s.change_value && (
        <div className="mt-1 flex items-center gap-1 text-sm text-muted-foreground">
          <Icon className="h-4 w-4" />
          {s.change_value}
        </div>
      )}
      <div className="mt-auto pt-4 text-xs text-muted-foreground">
        {s.source_url ? <a href={s.source_url} target="_blank" rel="noreferrer" className="underline-offset-2 hover:underline">{s.source_name}</a> : s.source_name}
        {s.as_of_date && <> · {fmtDate(s.as_of_date)}</>}
      </div>
    </div>
  );
}

export function TopicCard({ t, variant = "default" }: { t: TopicWithCount; variant?: "default" | "quiet" }) {
  return (
    <Link
      to="/topic/$id"
      params={{ id: t.id }}
      className={`group flex flex-col rounded-lg border p-5 transition-colors hover:border-foreground/40 ${variant === "quiet" ? "bg-secondary" : "bg-card"}`}
    >
      <div className="flex items-center justify-between">
        <span className="eyebrow !text-primary">{t.category}</span>
        <span className="flex items-center gap-1 font-mono text-xs text-muted-foreground">
          <TrendingUp className="h-3.5 w-3.5" /> {t.trend_score}
        </span>
      </div>
      <h3 className="mt-3 text-xl font-semibold leading-snug group-hover:underline group-hover:decoration-1 group-hover:underline-offset-4">{t.title}</h3>
      <p className="mt-2 line-clamp-3 text-sm text-muted-foreground">{t.summary}</p>
      <div className="mt-auto flex items-center justify-between pt-5 text-sm">
        <span className="flex items-center gap-1.5 text-muted-foreground"><Newspaper className="h-4 w-4" />{t.source_count} sources</span>
        <span className="flex items-center gap-1 font-medium text-primary">Explore context <ArrowRight className="h-4 w-4 transition-transform group-hover:translate-x-0.5" /></span>
      </div>
    </Link>
  );
}

export function Skeleton({ className = "" }: { className?: string }) {
  return <div className={`animate-pulse rounded-lg bg-secondary ${className}`} />;
}

export function GridSkeleton({ n = 4, h = "h-40" }: { n?: number; h?: string }) {
  return (
    <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
      {Array.from({ length: n }).map((_, i) => <Skeleton key={i} className={h} />)}
    </div>
  );
}

export function Empty({ text }: { text: string }) {
  return <div className="rounded-lg border border-dashed p-8 text-center text-sm text-muted-foreground">{text}</div>;
}

export function PageError({ error }: { error: Error }) {
  return (
    <div className="mx-auto max-w-xl px-4 py-24 text-center">
      <h1 className="text-3xl font-semibold">Couldn't load this page</h1>
      <p className="mt-2 text-sm text-muted-foreground">{error.message}</p>
      <Link to="/" className="mt-6 inline-block text-primary underline">Back home</Link>
    </div>
  );
}
