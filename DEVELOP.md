# Developer Instructions

- Use a 30-day trial org.
  - HXL widgets require orgs with full Data 360 licenses, so you must get a 30-day org with Data Cloud.
  - There are no Developer Edition orgs that provide full Data 360.
  - Scratch orgs are NOT supported for Data 360.
- Setup Data Cloud (this will take some time to complete)
- Enable Einstein
- Enable Agentforce Agents
- Enable Headless Experience Layer
- Enable Dev Hub and Sandbox source-tracking

Make sure you enable Dev Hub first before logging in and authorising the Org for development

You can deploy to either the Prod org or the sandbox.

Note: access.default_agent_user uses a placeholder (<placeholder@salesforce.com>) — replace it with a real Einstein Agent User username before deploying.

## Sample Data Import

The `data/` directory contains sample records (10 Accounts + 10 linked Opportunities) in sObject tree format. These exercises the `TopOpportunities` widget and Agentforce agent across all pipeline stages.

**Import into any org:**

```bash
./scripts/import-data.sh <org-alias-or-username>
# e.g.  ./scripts/import-data.sh DevHubTrial
```

Or manually with the Salesforce CLI:

```bash
sf data import tree --plan data/sample-data-plan.json --target-org <org>
```

**What's included (`data/sample-data.json`):**

| # | Account | Opportunity | Stage | Amount |
|---|---------|-------------|-------|--------|
| 1 | Adventure Trail Company | Adventure Gear Q4 Deal | Prospecting | $15,000 |
| 2 | Back Country Outpost | Back Country Fleet Upgrade | Qualification | $42,000 |
| 3 | Get Outside Suppliers | Get Outside Season Pass Bundle | Needs Analysis | $8,500 |
| 4 | National Parks Gear | National Parks Partnership | Proposal/Price Quote | $125,000 |
| 5 | River Mountain Outfitters | River Outfitters Expansion | Negotiation/Review | $67,000 |
| 6 | Trailblazer Unlimited | Trailblazer Enterprise License | Closed Won | $95,000 |
| 7 | Trail Expert Co. | Trail Expert Consulting | Prospecting | $22,000 |
| 8 | Trailhead Outdoor Supply | Trailhead Outdoor Wholesale | Qualification | $33,000 |
| 9 | Trail Ranger Outfitters | Ranger Outfitters Digital | Needs Analysis | $18,500 |
| 10 | Trek the Trail | Trek the Trail Summer Campaign | Closed Lost | $52,000 |

To add or modify records, edit `data/sample-data.json` and re-run the import.
