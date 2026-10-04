CREATE TABLE public.topics (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  category text NOT NULL,
  summary text NOT NULL,
  why_it_matters text[] NOT NULL DEFAULT '{}',
  key_facts text[] NOT NULL DEFAULT '{}',
  established text[] NOT NULL DEFAULT '{}',
  claimed text[] NOT NULL DEFAULT '{}',
  disputed text[] NOT NULL DEFAULT '{}',
  image_url text,
  trend_score int NOT NULL DEFAULT 50,
  published_at timestamptz NOT NULL DEFAULT now(),
  created_at timestamptz NOT NULL DEFAULT now()
);
CREATE TABLE public.articles (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  topic_id uuid NOT NULL REFERENCES public.topics(id) ON DELETE CASCADE,
  title text NOT NULL, source_name text NOT NULL, source_url text, source_type text NOT NULL,
  perspective text, summary text, published_at timestamptz NOT NULL DEFAULT now(),
  created_at timestamptz NOT NULL DEFAULT now()
);
CREATE TABLE public.perspectives (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  topic_id uuid NOT NULL REFERENCES public.topics(id) ON DELETE CASCADE,
  perspective_name text NOT NULL, title text NOT NULL, content text NOT NULL,
  evidence text, source_name text, created_at timestamptz NOT NULL DEFAULT now()
);
CREATE TABLE public.timeline_events (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  topic_id uuid NOT NULL REFERENCES public.topics(id) ON DELETE CASCADE,
  event_date date NOT NULL, title text NOT NULL, description text,
  source_name text, source_url text, created_at timestamptz NOT NULL DEFAULT now()
);
CREATE TABLE public.statistics (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  category text NOT NULL, name text NOT NULL, value text NOT NULL, unit text,
  change_value text, change_direction text, metric_type text,
  source_name text, source_url text, as_of_date date, featured boolean NOT NULL DEFAULT false,
  sort_order int NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now()
);

GRANT SELECT ON public.topics, public.articles, public.perspectives, public.timeline_events, public.statistics TO anon, authenticated;
GRANT ALL ON public.topics, public.articles, public.perspectives, public.timeline_events, public.statistics TO service_role;
ALTER TABLE public.topics ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.articles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.perspectives ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.timeline_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.statistics ENABLE ROW LEVEL SECURITY;
CREATE POLICY "public read" ON public.topics FOR SELECT TO anon, authenticated USING (true);
CREATE POLICY "public read" ON public.articles FOR SELECT TO anon, authenticated USING (true);
CREATE POLICY "public read" ON public.perspectives FOR SELECT TO anon, authenticated USING (true);
CREATE POLICY "public read" ON public.timeline_events FOR SELECT TO anon, authenticated USING (true);
CREATE POLICY "public read" ON public.statistics FOR SELECT TO anon, authenticated USING (true);

-- ===== SEED: topics =====
INSERT INTO public.topics (id,title,category,summary,why_it_matters,key_facts,established,claimed,disputed,trend_score,published_at) VALUES
('11111111-0000-0000-0000-000000000001','One Nation, One Election: the push for simultaneous polls','Politics',
'The Union Cabinet accepted the recommendations of the high-level committee led by former President Ram Nath Kovind to hold Lok Sabha and state assembly elections together. Two Constitution amendment bills were introduced in Parliament and referred to a Joint Parliamentary Committee. Supporters argue synchronised polls would cut costs and reduce governance disruption from the model code of conduct. Opposition parties and several constitutional experts question the impact on federalism and on states whose assemblies would have shortened terms.',
ARRAY['Would require constitutional amendments affecting how and when every state votes','Changes the frequency with which voters can signal approval or disapproval of governments','Has large implications for Election Commission logistics: EVMs, VVPATs and personnel','Sets a precedent for Centre–state balance under India''s federal structure'],
ARRAY['India held simultaneous elections from 1951–52 until 1967.','The Kovind committee submitted its report in March 2024.','The Cabinet approved the recommendations in September 2024.','The Constitution (129th Amendment) Bill was introduced in Lok Sabha in December 2024 and sent to a JPC.'],
ARRAY['Simultaneous polls were the norm until the cycle broke after 1967–1971 dissolutions.','The bills have been referred to a Joint Parliamentary Committee.','Constitutional amendments of this kind need a special majority in Parliament.'],
ARRAY['The government says synchronised polls will significantly reduce election spending.','Supporters claim frequent elections slow policy decisions due to the model code of conduct.','Opposition parties claim the move favours national parties over regional ones.'],
ARRAY['How large the actual cost savings would be is contested; estimates vary widely.','Whether ratification by half the states is legally required is debated among experts.','Evidence on whether simultaneous polls shift voter behaviour toward national parties is mixed.'],
92, now() - interval '2 days'),

('11111111-0000-0000-0000-000000000002','RBI holds the repo rate: what the pause signals','Economy',
'The Reserve Bank of India''s Monetary Policy Committee kept the policy repo rate unchanged at its latest meeting after a series of cuts earlier in the year. The central bank pointed to benign headline inflation but flagged global uncertainty and food price volatility. The decision affects home, auto and business loan rates as banks transmit policy changes to borrowers. Markets are now debating whether the easing cycle has ended or is merely paused.',
ARRAY['Determines the direction of EMIs on floating-rate loans for millions of households','Influences returns on fixed deposits and small savings','Shapes business borrowing costs and investment decisions','Signals how the RBI reads inflation and growth risks ahead'],
ARRAY['The repo rate stands at 5.50% (demo figure).','The MPC has six members: three from RBI and three external.','The RBI''s inflation target is 4% CPI with a tolerance band of 2–6%.','The policy stance was retained as "neutral".'],
ARRAY['The MPC voted to keep the repo rate unchanged.','CPI inflation has been below the 4% target in recent months per MoSPI data.','Transmission of earlier cuts to bank lending rates is still ongoing.'],
ARRAY['The RBI says the pause allows previous cuts to work through the economy.','Industry bodies claim further cuts are needed to revive private investment.'],
ARRAY['Whether low inflation is durable or driven by temporary food price effects.','The size of the impact of global tariffs on Indian growth.'],
88, now() - interval '1 day'),

('11111111-0000-0000-0000-000000000003','India''s GDP growth: strong headline, uneven ground','Economy',
'Official estimates show India remaining among the fastest-growing large economies, with real GDP growth around 7% in the most recent quarter. Growth has been led by services, government capital expenditure and manufacturing, while private consumption has recovered unevenly. Economists differ on the strength of rural demand and on the role of the GDP deflator in boosting real growth numbers. The data matters for jobs, tax revenue and India''s global investment pitch.',
ARRAY['Growth determines tax revenues available for welfare and infrastructure','Affects job creation, especially in services and construction','Shapes foreign investor sentiment and rupee stability','Uneven growth can widen urban–rural gaps even when the headline is strong'],
ARRAY['Real GDP grew about 7.8% in Q1 FY26 per NSO estimates (demo figure).','Gross Fixed Capital Formation remains above 30% of GDP.','Services account for over half of gross value added.','The NSO is revising the GDP base year to 2022-23.'],
ARRAY['India''s official GDP growth has exceeded 6.5% in each of the past three years.','Public capital expenditure has risen sharply since 2021.'],
ARRAY['The government says growth reflects structural reforms such as GST and IBC.','Some economists claim informal sector output is overstated by current methods.'],
ARRAY['The extent to which a low deflator inflates real growth figures.','How strong rural consumption actually is; survey and output data diverge.'],
74, now() - interval '4 days'),

('11111111-0000-0000-0000-000000000004','Food prices and India''s inflation puzzle','Economy',
'Retail inflation measured by the Consumer Price Index has eased significantly, falling below the RBI''s 4% target, largely due to a fall in vegetable and pulse prices. Core inflation, which excludes food and fuel, has stayed relatively stable. Households, however, often report that prices feel higher than official figures suggest. A new CPI series with updated weights is expected, which could change how inflation is measured.',
ARRAY['Food is close to half the CPI basket, so food prices drive household budgets','Inflation guides RBI''s interest rate decisions','Real wage growth depends on how prices compare with income growth','Changes to CPI methodology could alter how inflation is reported'],
ARRAY['CPI inflation was 2.1% in the latest month (demo figure).','Food has a weight of about 46% in the current CPI basket (2012 base).','A revised CPI series with a 2024 base year is being prepared by MoSPI.'],
ARRAY['Headline CPI is below the RBI target of 4%.','Vegetable prices have declined year-on-year.'],
ARRAY['The government attributes lower inflation to supply-side measures and buffer stocks.','Consumer groups claim official figures underweight services such as health and education.'],
ARRAY['Whether perceived inflation and measured inflation diverge meaningfully.','How durable the food price decline is given monsoon variability.'],
61, now() - interval '6 days'),

('11111111-0000-0000-0000-000000000005','Cybercrime: rising reports, and what the numbers really say','Crime',
'National Crime Records Bureau data and portal complaints show a steep increase in reported cybercrime, particularly online financial fraud. Officials say part of the rise reflects better reporting via the national cybercrime helpline 1930 and portal. Conviction rates for cybercrime remain low compared to overall IPC crimes. Experts caution that rising registrations do not by themselves prove that crime is rising at the same pace.',
ARRAY['Online fraud directly affects household savings, especially among older and first-time digital users','Rising digital payments make security a mainstream concern','Low conviction rates affect deterrence','Understanding reported vs. actual crime helps judge policing performance fairly'],
ARRAY['NCRB recorded 86,420 cybercrime cases in 2023 (demo figure based on NCRB trend).','Fraud is the motive in a majority of registered cybercrime cases.','The 1930 helpline and cybercrime.gov.in portal allow citizens to report fraud quickly.','Cybercrime charge-sheeting and conviction rates trail those of other crimes.'],
ARRAY['Registered cybercrime cases have increased year-on-year in NCRB reports.','A national reporting portal and helpline have been operational since 2019–2021.'],
ARRAY['Police officials claim higher numbers mostly reflect improved reporting.','Some security researchers claim actual fraud volume is far higher than registered cases.'],
ARRAY['The share of the increase due to more crime versus more reporting is uncertain.','Comparisons across states are difficult because registration practices differ.'],
79, now() - interval '3 days'),

('11111111-0000-0000-0000-000000000006','India''s approach to AI regulation and the DPDP rules','Technology',
'India has chosen a light-touch, guidelines-led approach to artificial intelligence rather than a single AI law, while operationalising the Digital Personal Data Protection Act, 2023 through new rules. The IndiaAI Mission is funding compute capacity and foundation models. Industry groups welcome flexibility, while civil society organisations raise concerns about government exemptions and deepfake harms. The framework will shape how AI products handle Indian users'' data.',
ARRAY['Determines how companies may collect and use personal data of Indian users','Affects startups building AI models and the cost of compliance','Shapes protections against deepfakes and misinformation','Defines the balance between innovation and individual rights'],
ARRAY['The DPDP Act was passed by Parliament in August 2023.','The DPDP Rules were notified in phases with an 18-month transition for most obligations.','The IndiaAI Mission was approved with an outlay of over Rs 10,000 crore in 2024.','India currently has no standalone AI-specific statute.'],
ARRAY['The DPDP Act creates a Data Protection Board to handle complaints.','The Act allows the government to exempt certain state agencies.'],
ARRAY['The government says the framework balances innovation with privacy.','Civil society groups claim exemptions weaken privacy protections.','Industry claims strict AI-specific laws would slow Indian startups.'],
ARRAY['Whether a guidelines-led approach can address deepfakes effectively.','How the Data Protection Board''s independence will work in practice.'],
70, now() - interval '5 days'),

('11111111-0000-0000-0000-000000000007','India''s women''s cricket after the World Cup win','Sports',
'India''s women''s team won the ICC Women''s ODI World Cup on home soil in November 2025, its first senior global title. The win has driven record viewership, sponsorship interest and a push to expand the Women''s Premier League. Former players and administrators say grassroots infrastructure and domestic pay still lag behind the men''s game. The question now is whether the momentum translates into broader participation.',
ARRAY['A landmark moment for women''s sport in India with large viewership','May shape investment in grassroots and domestic women''s cricket','Influences pay equity and professional pathways for women athletes','Tests whether elite success translates into participation'],
ARRAY['India won the 2025 ICC Women''s Cricket World Cup final in Navi Mumbai.','BCCI announced match-fee parity for centrally contracted women and men in 2022.','The Women''s Premier League launched in 2023 with five franchises.'],
ARRAY['India won the 2025 Women''s ODI World Cup.','Match fees for international games are equal for men and women.'],
ARRAY['BCCI says it will expand domestic structures for women''s cricket.','Former players claim annual contract gaps remain large.'],
ARRAY['How much grassroots participation has grown; reliable data is limited.'],
55, now() - interval '8 days');

-- ===== articles =====
INSERT INTO public.articles (topic_id,title,source_name,source_url,source_type,perspective,summary,published_at) VALUES
('11111111-0000-0000-0000-000000000001','Report of the High-Level Committee on Simultaneous Elections','Ministry of Law & Justice','https://legislative.gov.in','Government','Government / Official','Official committee report recommending a two-step plan for synchronised elections.', now()-interval '200 days'),
('11111111-0000-0000-0000-000000000001','Opposition parties unite against simultaneous polls bill','Demo National Daily','https://example.com/demo/onoe-opposition','Newspaper','Opposition / Critical','Coverage of parties arguing the bill undermines federalism.', now()-interval '30 days'),
('11111111-0000-0000-0000-000000000001','What the Constitution says about curtailing assembly terms','Demo Legal Review','https://example.com/demo/onoe-legal','Research','Expert','Constitutional scholars examine Articles 83 and 172.', now()-interval '20 days'),
('11111111-0000-0000-0000-000000000001','Cost of elections: what the data shows','Demo Policy Institute','https://example.com/demo/onoe-cost','Research','Independent Evidence','Analysis of ECI expenditure data and estimates.', now()-interval '10 days'),
('11111111-0000-0000-0000-000000000002','Monetary Policy Statement','Reserve Bank of India','https://rbi.org.in','Government','Government / Official','MPC resolution keeping repo rate unchanged with neutral stance.', now()-interval '1 day'),
('11111111-0000-0000-0000-000000000002','Industry seeks another rate cut to boost capex','Demo Business Standard','https://example.com/demo/rbi-industry','News','Industry','Industry chambers ask for further easing.', now()-interval '1 day'),
('11111111-0000-0000-0000-000000000002','Why the RBI paused: an economist''s read','Demo Economic Weekly','https://example.com/demo/rbi-expert','Research','Expert','Economists discuss the inflation outlook and transmission.', now()-interval '1 day'),
('11111111-0000-0000-0000-000000000002','What the rate pause means for your EMI','Demo Personal Finance','https://example.com/demo/rbi-emi','News','Public Impact','Explainer on loan and deposit rates.', now()-interval '12 hours'),
('11111111-0000-0000-0000-000000000003','Press note on quarterly GDP estimates','MoSPI / NSO','https://mospi.gov.in','Official Dataset','Government / Official','Quarterly estimates of GDP and GVA.', now()-interval '4 days'),
('11111111-0000-0000-0000-000000000003','IMF World Economic Outlook: India projections','IMF','https://www.imf.org','International','International','IMF growth projections for India.', now()-interval '15 days'),
('11111111-0000-0000-0000-000000000003','The deflator question in India''s growth data','Demo Economic Weekly','https://example.com/demo/gdp-deflator','Research','Expert','Economists debate real vs nominal growth.', now()-interval '3 days'),
('11111111-0000-0000-0000-000000000003','Rural demand: signs of recovery, unevenly','Demo National Daily','https://example.com/demo/gdp-rural','Newspaper','Public Impact','Ground report on rural consumption.', now()-interval '2 days'),
('11111111-0000-0000-0000-000000000004','Consumer Price Index press release','MoSPI / NSO','https://mospi.gov.in','Official Dataset','Government / Official','Monthly CPI release.', now()-interval '6 days'),
('11111111-0000-0000-0000-000000000004','Why prices feel higher than CPI says','Demo Personal Finance','https://example.com/demo/cpi-feel','News','Public Impact','Explainer on perceived vs measured inflation.', now()-interval '5 days'),
('11111111-0000-0000-0000-000000000004','Households'' inflation expectations survey','Reserve Bank of India','https://rbi.org.in','Research','Independent Evidence','RBI survey of household expectations.', now()-interval '20 days'),
('11111111-0000-0000-0000-000000000005','Crime in India annual report','NCRB','https://ncrb.gov.in','Official Dataset','Independent Evidence','Annual crime statistics including cybercrime.', now()-interval '60 days'),
('11111111-0000-0000-0000-000000000005','Indian Cyber Crime Coordination Centre advisory','Ministry of Home Affairs','https://cybercrime.gov.in','Government','Government / Official','Advisory on digital arrest and investment scams.', now()-interval '15 days'),
('11111111-0000-0000-0000-000000000005','Victims describe slow recovery of lost money','Demo National Daily','https://example.com/demo/cyber-victims','Newspaper','Public Impact','Reporting on victims of UPI fraud.', now()-interval '5 days'),
('11111111-0000-0000-0000-000000000005','Why conviction rates for cybercrime remain low','Demo Legal Review','https://example.com/demo/cyber-convictions','Research','Expert','Analysis of forensic capacity and jurisdiction issues.', now()-interval '3 days'),
('11111111-0000-0000-0000-000000000006','Digital Personal Data Protection Rules','MeitY','https://www.meity.gov.in','Government','Government / Official','Official notification of the DPDP Rules.', now()-interval '40 days'),
('11111111-0000-0000-0000-000000000006','Startups welcome light-touch AI governance','Demo Tech Daily','https://example.com/demo/ai-startups','News','Industry','Industry reaction to AI guidelines.', now()-interval '10 days'),
('11111111-0000-0000-0000-000000000006','Privacy groups flag exemptions in data law','Demo Rights Watch','https://example.com/demo/dpdp-rights','Research','Opposition / Critical','Civil society analysis of exemptions.', now()-interval '8 days'),
('11111111-0000-0000-0000-000000000006','How other countries regulate AI','Demo Global Policy','https://example.com/demo/ai-global','International','International','Comparison with EU AI Act and US approach.', now()-interval '12 days'),
('11111111-0000-0000-0000-000000000007','India win Women''s World Cup final','ICC','https://www.icc-cricket.com','News','Official','Match report from the final.', now()-interval '330 days'),
('11111111-0000-0000-0000-000000000007','What comes after the trophy for women''s cricket','Demo Sports Weekly','https://example.com/demo/wc-after','Newspaper','Expert','Former players on grassroots gaps.', now()-interval '30 days'),
('11111111-0000-0000-0000-000000000007','Girls'' academies see a surge in enrolment','Demo National Daily','https://example.com/demo/wc-academies','Newspaper','Public Impact','Ground report from cricket academies.', now()-interval '20 days');

-- ===== perspectives =====
INSERT INTO public.perspectives (topic_id,perspective_name,title,content,evidence,source_name) VALUES
('11111111-0000-0000-0000-000000000001','Government / Official','Synchronised polls for stable governance','The government states that simultaneous elections would reduce the cost of repeated polls, limit disruptions caused by the model code of conduct, and let governments focus on governance.','Kovind committee report; historical precedent of 1951–1967 elections.','Ministry of Law & Justice'),
('11111111-0000-0000-0000-000000000001','Opposition / Critical','A threat to federalism','Critics argue that curtailing state assembly terms to align with the Lok Sabha weakens states'' autonomy and may advantage national parties in campaigns.','Statements from multiple opposition parties; JPC submissions.','Demo National Daily'),
('11111111-0000-0000-0000-000000000001','Expert','Constitutional questions remain','Constitutional experts have raised concerns about mid-term dissolutions, hung assemblies, and whether state ratification is needed. Opinions differ.','Commentary by legal scholars on Articles 83, 172 and 368.','Demo Legal Review'),
('11111111-0000-0000-0000-000000000001','Independent Evidence','Savings are real but modest','Independent data shows elections are costly, but the direct cost is a small fraction of total government spending. Evidence on governance gains is limited.','ECI expenditure records; policy institute estimates.','Demo Policy Institute'),
('11111111-0000-0000-0000-000000000002','Government / Official','Let earlier cuts transmit','The RBI states that pausing allows previous rate cuts to transmit to lending rates while it monitors global risks.','MPC resolution and Governor''s statement.','Reserve Bank of India'),
('11111111-0000-0000-0000-000000000002','Industry','More room to cut','Industry bodies argue that with inflation below target, real interest rates are high and further cuts would support private investment.','Chamber of commerce pre-policy memorandum.','Demo Business Standard'),
('11111111-0000-0000-0000-000000000002','Expert','A sensible wait','Several economists say a pause is reasonable given food price volatility and global uncertainty, though views on the next move differ.','Economist poll ahead of the policy.','Demo Economic Weekly'),
('11111111-0000-0000-0000-000000000002','Public Impact','EMIs steady for now','For borrowers, floating-rate loan EMIs remain unchanged; depositors may see FD rates edge down as earlier cuts pass through.','Bank rate announcements.','Demo Personal Finance'),
('11111111-0000-0000-0000-000000000003','Government / Official','Fastest-growing major economy','The government states that strong growth reflects reforms, public capex and robust services exports.','NSO quarterly estimates.','MoSPI / NSO'),
('11111111-0000-0000-0000-000000000003','Expert','Read the deflator carefully','Some economists argue low wholesale inflation lowered the deflator, flattering real growth. Others say the effect is small.','Nominal vs real GDP comparisons.','Demo Economic Weekly'),
('11111111-0000-0000-0000-000000000003','International','Positive outlook with risks','International institutions project India to remain among the fastest-growing large economies, citing tariff and global demand risks.','IMF World Economic Outlook.','IMF'),
('11111111-0000-0000-0000-000000000003','Public Impact','Growth that doesn''t feel even','Ground reporting suggests urban demand is stronger than rural demand, and job creation has not kept pace everywhere.','PLFS and consumption survey indicators.','Demo National Daily'),
('11111111-0000-0000-0000-000000000004','Government / Official','Supply measures working','The government states that buffer stock releases and supply-side interventions helped lower food prices.','Department of Consumer Affairs statements.','MoSPI / NSO'),
('11111111-0000-0000-0000-000000000004','Public Impact','Prices still feel high','Households report that rents, school fees and healthcare have kept rising, even as vegetables got cheaper.','RBI household inflation expectations survey.','Reserve Bank of India'),
('11111111-0000-0000-0000-000000000004','Expert','Base effects matter','Economists note that part of the fall is due to high prices a year ago (base effects); inflation may rise again as these fade.','Month-on-month CPI data.','Demo Economic Weekly'),
('11111111-0000-0000-0000-000000000005','Government / Official','Better reporting, stronger response','The government states that the 1930 helpline and portal have made reporting easier, and that funds worth crores have been frozen before reaching fraudsters.','I4C data releases.','Ministry of Home Affairs'),
('11111111-0000-0000-0000-000000000005','Independent Evidence','Registrations rising sharply','NCRB data shows registered cybercrime cases rising each year. Registrations measure reported cases, not total incidence.','NCRB Crime in India reports.','NCRB'),
('11111111-0000-0000-0000-000000000005','Expert','Investigation capacity is the bottleneck','Experts have raised concerns about limited digital forensics capacity and cross-state jurisdiction, which keep conviction rates low.','Charge-sheet and conviction rate data.','Demo Legal Review'),
('11111111-0000-0000-0000-000000000005','Public Impact','Victims struggle to recover money','Victims report delays in recovering money, with older citizens and first-time users particularly affected.','Victim interviews; bank grievance data.','Demo National Daily'),
('11111111-0000-0000-0000-000000000006','Government / Official','Innovation with safeguards','The government states that a principles-based approach lets India build AI capacity while the DPDP Act protects personal data.','MeitY notifications; IndiaAI Mission documents.','MeitY'),
('11111111-0000-0000-0000-000000000006','Industry','Flexibility helps startups','Industry groups argue that avoiding a rigid AI law keeps compliance costs low and lets Indian startups compete.','Industry association statements.','Demo Tech Daily'),
('11111111-0000-0000-0000-000000000006','Opposition / Critical','Exemptions weaken rights','Civil society groups argue that broad exemptions for government agencies and limited board independence weaken privacy protections.','Analyses of Section 17 of the DPDP Act.','Demo Rights Watch'),
('11111111-0000-0000-0000-000000000006','International','A middle path','Compared with the EU''s risk-based AI Act and the US''s sector-led approach, India sits between, emphasising capacity building.','Comparative policy reviews.','Demo Global Policy'),
('11111111-0000-0000-0000-000000000007','Official','A historic milestone','BCCI and ICC describe the win as a turning point for women''s cricket in India.','Official statements.','ICC'),
('11111111-0000-0000-0000-000000000007','Expert','Build the base','Former players say domestic pay, coaching and facilities for girls need sustained investment for the success to last.','Interviews with former internationals.','Demo Sports Weekly'),
('11111111-0000-0000-0000-000000000007','Public Impact','More girls picking up the bat','Academies report increased enrolment of girls, though reliable national data is limited.','Academy enrolment reports.','Demo National Daily');

-- ===== timeline =====
INSERT INTO public.timeline_events (topic_id,event_date,title,description,source_name,source_url) VALUES
('11111111-0000-0000-0000-000000000001','1967-02-15','Simultaneous cycle breaks','Premature dissolution of several state assemblies begins to break the synchronised election cycle.','Election Commission of India','https://eci.gov.in'),
('11111111-0000-0000-0000-000000000001','1999-05-01','Law Commission recommends synchronised polls','The 170th Law Commission report suggests returning to simultaneous elections.','Law Commission of India','https://lawcommissionofindia.nic.in'),
('11111111-0000-0000-0000-000000000001','2023-09-02','High-level committee formed','Government constitutes a committee chaired by former President Ram Nath Kovind.','Ministry of Law & Justice','https://legislative.gov.in'),
('11111111-0000-0000-0000-000000000001','2024-03-14','Committee submits report','The report recommends a two-step implementation plan.','Ministry of Law & Justice','https://legislative.gov.in'),
('11111111-0000-0000-0000-000000000001','2024-09-18','Cabinet accepts recommendations','The Union Cabinet approves the committee''s recommendations.','PIB','https://pib.gov.in'),
('11111111-0000-0000-0000-000000000001','2024-12-17','Bills introduced, sent to JPC','Constitution amendment bills are introduced and referred to a Joint Parliamentary Committee.','PIB','https://pib.gov.in'),
('11111111-0000-0000-0000-000000000002','2023-02-08','Repo rate peaks at 6.50%','The RBI completes its tightening cycle after post-pandemic inflation.','Reserve Bank of India','https://rbi.org.in'),
('11111111-0000-0000-0000-000000000002','2025-02-07','First cut in five years','The MPC cuts the repo rate by 25 bps to 6.25%.','Reserve Bank of India','https://rbi.org.in'),
('11111111-0000-0000-0000-000000000002','2025-04-09','Second cut, stance to accommodative','Repo rate cut to 6.00%.','Reserve Bank of India','https://rbi.org.in'),
('11111111-0000-0000-0000-000000000002','2025-06-06','Jumbo 50 bps cut','Repo rate cut to 5.50%; stance changed to neutral.','Reserve Bank of India','https://rbi.org.in'),
('11111111-0000-0000-0000-000000000002','2025-08-06','Pause begins','MPC keeps the rate unchanged, citing transmission and global uncertainty.','Reserve Bank of India','https://rbi.org.in'),
('11111111-0000-0000-0000-000000000003','2020-06-30','Pandemic contraction','GDP contracts sharply in Q1 FY21 during lockdowns.','MoSPI / NSO','https://mospi.gov.in'),
('11111111-0000-0000-0000-000000000003','2022-02-01','Capex push in Budget','Union Budget sharply increases public capital expenditure.','Ministry of Finance','https://www.indiabudget.gov.in'),
('11111111-0000-0000-0000-000000000003','2024-05-31','FY24 growth estimated above 8%','Provisional estimates show strong growth.','MoSPI / NSO','https://mospi.gov.in'),
('11111111-0000-0000-0000-000000000003','2025-08-29','Q1 FY26 beats expectations','Real GDP growth estimated at 7.8%.','MoSPI / NSO','https://mospi.gov.in'),
('11111111-0000-0000-0000-000000000004','2023-07-12','Tomato price spike','Vegetable inflation drives CPI above 7%.','MoSPI / NSO','https://mospi.gov.in'),
('11111111-0000-0000-0000-000000000004','2024-10-14','Food inflation peaks again','CPI rises above 6% on vegetable prices.','MoSPI / NSO','https://mospi.gov.in'),
('11111111-0000-0000-0000-000000000004','2025-03-12','Inflation falls below 4%','Easing food prices bring CPI under target.','MoSPI / NSO','https://mospi.gov.in'),
('11111111-0000-0000-0000-000000000004','2025-07-14','Multi-year low','CPI inflation falls to around 2%.','MoSPI / NSO','https://mospi.gov.in'),
('11111111-0000-0000-0000-000000000005','2019-08-30','National cybercrime portal launched','cybercrime.gov.in becomes operational for all crime types.','Ministry of Home Affairs','https://cybercrime.gov.in'),
('11111111-0000-0000-0000-000000000005','2021-04-01','1930 helpline for financial fraud','Citizen Financial Cyber Fraud Reporting system expands nationwide.','Ministry of Home Affairs','https://cybercrime.gov.in'),
('11111111-0000-0000-0000-000000000005','2023-12-04','NCRB reports sharp rise','Crime in India 2022 shows cybercrime up significantly.','NCRB','https://ncrb.gov.in'),
('11111111-0000-0000-0000-000000000005','2024-10-27','"Digital arrest" warnings','Government issues public warnings about impersonation scams.','PIB','https://pib.gov.in'),
('11111111-0000-0000-0000-000000000006','2017-08-24','Privacy declared a fundamental right','Supreme Court''s Puttaswamy judgment.','Supreme Court of India','https://main.sci.gov.in'),
('11111111-0000-0000-0000-000000000006','2023-08-11','DPDP Act enacted','Digital Personal Data Protection Act receives assent.','MeitY','https://www.meity.gov.in'),
('11111111-0000-0000-0000-000000000006','2024-03-07','IndiaAI Mission approved','Cabinet approves over Rs 10,000 crore for AI compute and models.','PIB','https://pib.gov.in'),
('11111111-0000-0000-0000-000000000006','2025-11-14','DPDP Rules notified','Rules notified with phased implementation.','MeitY','https://www.meity.gov.in'),
('11111111-0000-0000-0000-000000000007','2017-07-23','Lord''s final heartbreak','India lose the 2017 World Cup final narrowly.','ICC','https://www.icc-cricket.com'),
('11111111-0000-0000-0000-000000000007','2022-10-27','Match-fee parity','BCCI announces equal match fees for men and women.','BCCI','https://www.bcci.tv'),
('11111111-0000-0000-0000-000000000007','2023-03-04','WPL launches','The first Women''s Premier League season begins.','BCCI','https://www.bcci.tv'),
('11111111-0000-0000-0000-000000000007','2025-11-02','World champions','India win the Women''s ODI World Cup final in Navi Mumbai.','ICC','https://www.icc-cricket.com');

-- ===== statistics =====
INSERT INTO public.statistics (category,name,value,unit,change_value,change_direction,metric_type,source_name,source_url,as_of_date,featured,sort_order) VALUES
('Economy','GDP growth','7.8','%','+1.3 pp YoY','up','Estimate','MoSPI / NSO','https://mospi.gov.in','2025-08-29',true,1),
('Economy','CPI inflation','2.1','%','-1.0 pp MoM','down','Rate','MoSPI / NSO','https://mospi.gov.in','2025-07-14',true,2),
('Economy','Repo rate','5.50','%','Unchanged','flat','Policy rate','Reserve Bank of India','https://rbi.org.in','2025-08-06',true,3),
('Economy','Unemployment rate','5.6','%','-0.1 pp','down','Survey estimate','PLFS (MoSPI)','https://mospi.gov.in','2025-07-15',true,4),
('Economy','Sensex','81,200','pts','+0.8% week','up','Market index','BSE','https://www.bseindia.com','2025-08-29',false,5),
('Crime','Reported cognisable crimes','62.4','lakh cases','+7.2% YoY','up','Reported cases','NCRB','https://ncrb.gov.in','2023-12-31',false,1),
('Crime','Crime rate','422','per lakh pop.','+12 YoY','up','Rate per population','NCRB','https://ncrb.gov.in','2023-12-31',false,2),
('Crime','IPC conviction rate','54','%','-2 pp','down','Convictions','NCRB','https://ncrb.gov.in','2023-12-31',false,3),
('Crime','Cybercrime cases','86,420','reported cases','+31% YoY','up','Reported cases','NCRB','https://ncrb.gov.in','2023-12-31',false,4),
('Politics','Lok Sabha 2024 turnout','65.8','%','-1.6 pp vs 2019','down','Official count','Election Commission of India','https://eci.gov.in','2024-06-04',false,1),
('Politics','Women MPs in Lok Sabha','74','of 543','-4 vs 2019','down','Official count','Election Commission of India','https://eci.gov.in','2024-06-04',false,2),
('Politics','Registered electors','96.8','crore','+7.2 crore vs 2019','up','Official count','Election Commission of India','https://eci.gov.in','2024-06-04',false,3),
('Technology','Monthly UPI transactions','20.0','billion','+34% YoY','up','Official count','NPCI','https://www.npci.org.in','2025-08-31',false,1),
('Technology','Internet subscribers','97.0','crore','+4% YoY','up','Official count','TRAI','https://www.trai.gov.in','2025-06-30',false,2),
('Technology','IndiaAI GPUs onboarded','34,000','GPUs','+16,000','up','Official claim','MeitY','https://www.meity.gov.in','2025-05-30',false,3),
('Sports','WC final viewership','~185','million viewers','Record for women''s cricket','up','Broadcaster estimate','Demo broadcaster data','https://example.com/demo/viewership','2025-11-03',false,1),
('Sports','WPL franchises','5','teams','Since 2023','flat','Official count','BCCI','https://www.bcci.tv','2025-03-15',false,2),
('Sports','Paris 2024 Olympic medals','6','medals','-1 vs Tokyo 2020','down','Official count','IOC','https://olympics.com','2024-08-11',false,3);
