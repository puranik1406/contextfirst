# Context — System Architecture

## 1. High-Level Architecture

```mermaid
flowchart TD

    A["Real News Sources"] --> B["News API"]

    B --> C["Backend / API Layer"]

    C --> D["Fetch & Filter"]
    D --> E["Categorize News"]
    E --> F["Group Related Articles"]
    F --> G["Trending Topics"]

    G --> H["Supabase / PostgreSQL"]

    G --> I["AI Context Layer"]

    I --> I1["Summarization"]
    I --> I2["Perspective Analysis"]
    I --> I3["Facts vs Claims"]
    I --> I4["Timeline Generation"]
    I --> I5["Context / Why It Matters"]

    H --> J["React Frontend"]
    I --> J

    J --> K["Home"]
    J --> L["Category Dashboards"]
    J --> M["Topic Detail"]
    
    M --> M1["What Happened"]
    M --> M2["Key Facts"]
    M --> M3["Different Perspectives"]
    M --> M4["Timeline"]
    M --> M5["Facts vs Claims"]
    M --> M6["Sources"]
    M --> M7["AI Overview"]
```

---

## 2. Simplified Data Flow

```mermaid
flowchart LR

    A["News API"] 
        --> B["Backend"]

    B --> C["Real Articles"]

    C --> D["Filtering & Categorization"]

    D --> E["Topic Clustering"]

    E --> F["Trending Topics"]

    F --> G["AI Context Layer"]

    G --> H["Summaries"]
    G --> I["Perspectives"]
    G --> J["Timeline"]
    G --> K["Facts / Claims"]

    F --> L["Supabase"]

    H --> M["Frontend"]
    I --> M
    J --> M
    K --> M
    L --> M

    M --> N["User"]
```

---

# 3. Detailed Architecture

```mermaid
flowchart TB

    %% =========================
    %% DATA SOURCES
    %% =========================

    subgraph SOURCES["REAL DATA SOURCES"]

        NEWS["News API"]
        GOV["Government / Official Sources"]
        DATA["Official Statistics / Datasets"]

    end


    %% =========================
    %% BACKEND
    %% =========================

    subgraph BACKEND["BACKEND / DATA PROCESSING"]

        FETCH["Fetch Current News"]

        FILTER["Filter Relevant Articles"]

        CATEGORY["Categorize"]

        DEDUPE["Deduplicate"]

        CLUSTER["Group Related Articles"]

        TREND["Calculate Trending Topics"]

        CACHE["Cache Results"]

    end


    %% =========================
    %% DATABASE
    %% =========================

    subgraph DB["SUPABASE / POSTGRESQL"]

        TOPICS[("Topics")]

        ARTICLES[("Articles")]

        PERSPECTIVES[("Perspectives")]

        TIMELINE[("Timeline Events")]

        STATS[("Statistics")]

    end


    %% =========================
    %% AI
    %% =========================

    subgraph AI["AI CONTEXT LAYER"]

        SUMMARY["What Happened?"]

        FACTS["Key Facts"]

        PERSPECTIVE_AI["Perspective Analysis"]

        CLAIMS["Facts vs Claims"]

        TIMELINE_AI["Timeline Extraction"]

        IMPORTANCE["Why It Matters"]

    end


    %% =========================
    %% FRONTEND
    %% =========================

    subgraph FRONTEND["REACT FRONTEND"]

        HOME["Home"]

        CATEGORY_PAGE["Category Dashboard"]

        TRENDING["Trending Topics"]

        TOPIC["Topic Detail"]

        SOURCES["Sources"]

        AI_OVERVIEW["AI Overview"]

    end


    %% DATA SOURCE → BACKEND

    NEWS --> FETCH
    GOV --> FETCH
    DATA --> FETCH

    FETCH --> FILTER
    FILTER --> CATEGORY
    CATEGORY --> DEDUPE
    DEDUPE --> CLUSTER
    CLUSTER --> TREND

    TREND --> CACHE

    %% DATABASE

    CACHE --> TOPICS
    CACHE --> ARTICLES

    ARTICLES --> TOPICS

    TOPICS --> PERSPECTIVES
    TOPICS --> TIMELINE

    DATA --> STATS

    %% AI

    TOPICS --> SUMMARY
    ARTICLES --> SUMMARY

    ARTICLES --> FACTS
    ARTICLES --> PERSPECTIVE_AI
    ARTICLES --> CLAIMS
    ARTICLES --> TIMELINE_AI
    ARTICLES --> IMPORTANCE

    %% AI → DATABASE

    SUMMARY --> TOPICS
    FACTS --> TOPICS
    PERSPECTIVE_AI --> PERSPECTIVES
    CLAIMS --> PERSPECTIVES
    TIMELINE_AI --> TIMELINE

    %% DATABASE → FRONTEND

    TOPICS --> HOME
    STATS --> HOME

    TOPICS --> CATEGORY_PAGE

    TOPICS --> TRENDING

    TOPICS --> TOPIC

    ARTICLES --> SOURCES

    PERSPECTIVES --> TOPIC
    TIMELINE --> TOPIC

    TOPIC --> AI_OVERVIEW
```

---

# 4. Topic-Level Data Flow

The most important part of Context is the flow from **multiple articles → one understandable story**.

```mermaid
flowchart TD

    A1["Article 1<br/>Source A"]
    A2["Article 2<br/>Source B"]
    A3["Article 3<br/>Source C"]
    A4["Article 4<br/>Source D"]

    A1 --> B["Article Processing"]
    A2 --> B
    A3 --> B
    A4 --> B

    B --> C["Topic Clustering"]

    C --> D["Single Topic"]

    D --> E["AI Context Analysis"]

    E --> F["Summary"]
    E --> G["Key Facts"]
    E --> H["Perspectives"]
    E --> I["Timeline"]
    E --> J["Facts vs Claims"]
    E --> K["Why It Matters"]

    D --> L["Original Sources"]

    F --> M["Topic Detail Page"]
    G --> M
    H --> M
    I --> M
    J --> M
    K --> M
    L --> M
```

---

# 5. Example

For example, suppose multiple sources report on the same RBI announcement:

```mermaid
flowchart LR

    A["Source A<br/>RBI announcement"]
    B["Source B<br/>Economic newspaper"]
    C["Source C<br/>Business news"]
    D["Source D<br/>Expert analysis"]

    A --> E["Same Event / Topic"]
    B --> E
    C --> E
    D --> E

    E --> F["Context AI"]

    F --> G["What happened?"]
    F --> H["Official position"]
    F --> I["Expert perspective"]
    F --> J["Market perspective"]
    F --> K["Established facts"]
    F --> L["Uncertainty"]

    G --> M["User sees ONE<br/>complete story"]
    H --> M
    I --> M
    J --> M
    K --> M
    L --> M
```

---

# 6. Core Product Flow

```mermaid
flowchart TD

    A["User opens Context"]

    A --> B["Home"]

    B --> C["Trending Now"]

    C --> D["Select Topic"]

    D --> E["What Happened?"]

    E --> F["Key Facts"]

    F --> G["Different Perspectives"]

    G --> H["How We Got Here"]

    H --> I["Facts vs Claims"]

    I --> J["Why It Matters"]

    J --> K["Coverage & Sources"]

    K --> L["AI Overview"]

    L --> M["You May Be Missing"]

    M --> N["Related Topic"]
```

---

# 7. Architecture Principle

```mermaid
flowchart LR

    A["REAL NEWS"] --> B["ORGANIZE"]

    B --> C["UNDERSTAND"]

    C --> D["COMPARE"]

    D --> E["CONTEXTUALIZE"]

    E --> F["USER"]

    A1["News APIs / Official Sources"] -.-> A
    B1["Filtering / Categorization / Clustering"] -.-> B
    C1["AI Summarization"] -.-> C
    D1["Multiple Perspectives"] -.-> D
    E1["Timeline / Facts / Claims"] -.-> E
```

**Core principle:**

> **Real news provides the information. AI provides the context.**

AI should never become the source of truth. It should operate on retrieved source material and clearly communicate uncertainty or disagreement.
