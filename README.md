# Context First

**Context First** is an AI-powered news understanding platform designed to help users go beyond headlines and understand the bigger picture behind current events.

Instead of showing users a single personalized narrative, Context First brings together multiple sources covering the same topic and uses AI to help users understand the **context, timeline, perspectives, facts, and claims** surrounding a story.

> **Don't just know what happened. Understand why it happened.**

---

## Problem

Modern news consumption presents several challenges:

* Information overload makes it difficult to identify what actually matters.
* Personalized feeds can create filter bubbles and expose users to limited viewpoints.
* Different sources often present different interpretations of the same event.
* Breaking news frequently lacks the historical context needed to understand it.
* Facts, claims, opinions, and disputed information can become mixed together.
* Understanding a major event often requires manually reading multiple articles.

---

## Key Features

### 1. Multi-Perspective News

View multiple sources covering the **same topic** rather than consuming isolated articles.

* Compare different sources and interpretations.
* See how different perspectives frame the same event.
* Access the original articles directly.
* Avoid forcing every story into a simple political left/right classification.

### 2. Context & Timeline

Understand **how the current event came to happen**.

* Chronological timeline of related events.
* Previous decisions and developments.
* Connections between past events and the current story.
* Clear explanation of why the event matters.

### 3. Facts, Claims & Insights

Separate information into meaningful categories.

* Verified facts
* Claims and statements
* Opinions and analysis
* Uncertain or disputed information
* Relevant statistics
* AI-generated contextual summaries
* **What You May Be Missing** — overlooked facts or perspectives

---

## How It Works

```text
Real News Sources
       ↓
News APIs / Sources
       ↓
Data Processing
       ↓
Filtering & Categorization
       ↓
Related Article Grouping
       ↓
Trending Topics
       ↓
AI Context Layer
       ↓
Summary • Perspectives • Timeline
Facts vs Claims • Insights
       ↓
Context First
```

### Core Principle

> **Real news provides the information. AI provides the context.**

AI should operate on retrieved source material rather than becoming the source of truth itself.

---

## Architecture

The current frontend is built as a modern web application and is designed to consume real news data and AI-generated context.

```text
┌─────────────────────────┐
│     Real News Sources   │
│   News APIs / Sources   │
└────────────┬────────────┘
             ↓
┌─────────────────────────┐
│     Data Processing     │
│ Filter • Categorize     │
│ Deduplicate • Group     │
└────────────┬────────────┘
             ↓
┌─────────────────────────┐
│    Trending Topics      │
└────────────┬────────────┘
             ↓
┌─────────────────────────┐
│     AI Context Layer    │
│ Summary • Perspectives   │
│ Timeline • Facts/Claims  │
└────────────┬────────────┘
             ↓
┌─────────────────────────┐
│     Context First UI     │
│ Dashboard • Topics       │
│ Categories • Search      │
└─────────────────────────┘
```

---

## Current Categories

The application is organized around major areas of news:

* **Politics**
* **Economy**
* **Crime**
* **Technology**
* **Sports**

Each category can provide relevant trending topics, statistics, and news coverage.

---

## Tech Stack

### Frontend

* React
* TypeScript
* Vite
* Tailwind CSS
* Modern responsive UI

### Data & Backend

The application is designed to integrate with:

* News APIs
* Official government sources
* Official statistics and datasets
* Database/storage services

### AI

AI can be used for:

* News summarization
* Perspective analysis
* Timeline generation
* Facts vs claims classification
* Context generation
* Identifying potentially missing information

---

## Project Structure

```text
src/
├── components/
│   ├── ui/
│   └── ...
│
├── pages/
│   ├── Index
│   └── ...
│
├── hooks/
├── lib/
├── App.tsx
├── main.tsx
└── ...
```

The exact structure may evolve as the project is developed.

---

## Data Integrity

Context First is designed around **source transparency**.

The application should:

* Preserve original article URLs.
* Attribute information to its sources.
* Distinguish facts from claims and opinions.
* Clearly communicate uncertainty.
* Avoid fabricating statistics or news.
* Avoid treating AI-generated information as independently verified fact.

AI-generated content should be based on retrieved source material whenever possible.

---

## Future Improvements

Potential future development includes:

* Real-time news ingestion
* More advanced topic clustering
* Better source comparison
* Government performance tracking
* More official datasets and statistics
* Automated event timelines
* Source credibility and factuality indicators
* Personalized topic tracking without creating filter bubbles
* Multilingual Indian news support
* Regional/local news coverage
* Improved AI fact verification

---

# Build with Lovable

This project was built with [Lovable](https://lovable.dev/).

**Live app**: https://contextfirst.lovable.app

## Build with Lovable

Continue developing this project in the [Lovable editor](https://lovable.dev/projects/c41d8c7a-4e72-448f-9cdb-b0b8c9384c7d).

* **Ship faster**: describe what you want to build and Lovable handles the code.
* **Stay in sync**: every change made in Lovable is committed straight into this repository.
* **Full ownership**: this code is yours. Push to `main` on GitHub and your changes sync back into Lovable, ready for your next prompt.

---

# Development

Prefer working locally? You need Node.js and npm — [install with nvm](https://github.com/nvm-sh/nvm#installing-and-updating).

```bash
git clone <this-repository-url>
cd <repository-name>
npm i
npm run dev
```

The development server will provide a local URL, typically:

```text
http://localhost:5173
```

---

## Environment Variables

If external APIs are integrated, create a `.env` file in the project root.

Example:

```env
VITE_NEWS_API_KEY=your_news_api_key
VITE_GEMINI_API_KEY=your_gemini_api_key
```

**Do not commit API keys to GitHub.**

Add the following to `.gitignore` if they are not already present:

```text
.env
.env.local
```

For production, API keys should preferably be handled through a backend rather than exposed directly in the frontend.

---

## Contributing

1. Clone the repository.
2. Create a new branch.
3. Make your changes.
4. Test the application locally.
5. Commit your changes.
6. Push the branch.
7. Open a pull request.

---

## License

This project is currently being developed as a prototype/hackathon project.

Add an appropriate open-source license before publicly distributing the project.

---

## Project Vision

**Context First** aims to make news consumption more informed, transparent, and contextual.

Instead of asking:

> **"What is the news?"**

Context First asks:

> **"What happened, what led to it, what does the evidence say, how is it being interpreted, and what might I be missing?"**
