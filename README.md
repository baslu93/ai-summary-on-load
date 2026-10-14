# AI Summary On Load

<a href="https://githubsfdeploy.herokuapp.com?owner=baslu93&repo=ai-summary-on-load&ref=main">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>

A Salesforce LWC that automatically generates an AI-powered record summary when visible, with no user interaction required.

![AI Summary On Load](docs/screenshot.png)

Standard Salesforce AI summaries generate context when a user clicks a button. This component changes that interaction by running automatically as soon as it becomes visible.

While the Prompt Template runs in the background, the card takes up very little space, showing only a pulsing "AI Summary" title with a sparkle icon. Once the response is ready, the full summary renders directly inside the card, giving users immediate context the moment they open a record.

> [!WARNING]  
> This component consumes tokens on page load. Consider using it for orgs on an unmetered token tier.

## Setup

### 1. Add the component to a record page

Open App Builder on any Record Page, drag **AI Summary On Load** onto the layout and select the Prompt Template of type **Record Summary** you want to use. Save and activate the page.

### 2. Open a record

Navigate to any record of that object type and the summary will appear automatically on load.

## Components

| Component | Type | Description |
|---|---|---|
| `aiSummaryOnLoad` | LWC | Renders the AI-generated summary card on a record page. |
| `AiSummaryGenerateFromPrompt` | Apex | Calls the Einstein LLM API to run the prompt template against the current record. |
| `AiSummaryPromptsFilterByObject` | Apex | Dynamic picklist that filters available prompt templates by the page's object type, used in App Builder configuration. |


## Test

```bash
sf org create scratch --definition-file config/project-scratch-def.json --alias ai-summary-on-load
sf project deploy start --source-dir main --target-org ai-summary-on-load
sf project deploy start --source-dir test --target-org ai-summary-on-load
recordId=$(sf data query --query "SELECT Id FROM Account LIMIT 1" --target-org ai-summary-on-load --json | jq -r '.result.records[0].Id')
sf org open --target-org ai-summary-on-load --path /lightning/r/Account/$recordId/view
```

## Requirements

- Salesforce org with Generative AI enabled
