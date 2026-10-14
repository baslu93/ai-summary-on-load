import { LightningElement, api, track } from 'lwc';
import generate from '@salesforce/apex/AiSummaryGenerateFromPrompt.generate';

export default class AiSummaryOnLoad extends LightningElement {
    @api recordId;
    @api promptTemplate;
    @track richText;
    @track hasAnswer = false;

    get iconClass() {
        return this.hasAnswer ? 'ai-sparkle-icon' : 'ai-sparkle-icon pulse';
    }

    get titleChars() {
        return [...'AI Summary'].map((char, i) => ({
            index: i,
            char: char === ' ' ? ' ' : char,
            cssClass: this.hasAnswer ? '' : 'pulse',
            style: `animation-delay: ${i * 100}ms`
        }));
    }

    async connectedCallback() {
        if (this.promptTemplate && this.recordId) {
            this.loadSummary();
        }
    }

    async loadSummary() {
        try {
            const result = await generate({
                promptTemplateDeveloperName: this.promptTemplate,
                recordId: this.recordId
            });
            this.richText = result;
            this.hasAnswer = true;
        } catch (error) {
            console.error('Error generating summary:', error);
        }
    }
}
