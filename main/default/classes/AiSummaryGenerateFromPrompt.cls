public with sharing class AiSummaryGenerateFromPrompt {

    @AuraEnabled
    public static String generate(String promptTemplateDeveloperName, String recordId) {
        ConnectApi.EinsteinPromptTemplateGenerationsRepresentation result;
        try {
            ConnectApi.EinsteinPromptTemplateGenerationsInput input = new ConnectApi.EinsteinPromptTemplateGenerationsInput();
            input.isPreview = false;

            Schema.SObjectType sObjectType = ((Id) recordId).getSObjectType();
            String objectName = sObjectType.getDescribe().getName();

            ConnectApi.WrappedValue recordValue = new ConnectApi.WrappedValue();
            recordValue.value = new Map<String, Object>{ 'id' => recordId };

            input.inputParams = new Map<String, ConnectApi.WrappedValue>{
                'Input:' + objectName => recordValue
            };

            input.additionalConfig = new ConnectApi.EinsteinLLMAdditionalConfigInput();
            input.additionalConfig.numGenerations = 1;

            result = ConnectApi.EinsteinLLM.generateMessagesForPromptTemplate(promptTemplateDeveloperName, input);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

        if (result?.generations == null || result.generations.isEmpty()) {
            throw new AuraHandledException('No response generated.');
        }

        return result.generations[0]?.text;
    }
}
