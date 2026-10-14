global class AiSummaryPromptsFilterByObject extends VisualEditor.DynamicPicklist {
    private static final String PROMPT_TEMPLATE_TYPE = 'einstein_gpt__recordSummary';
    private static final String RELATED_ENTITY_FIELD = 'RelatedEntity';
    private static final String IS_ACTIVE_FIELD = 'IsActive';
    private static final String MASTER_LABEL_FIELD = 'MasterLabel';
    private static final String DEVELOPER_NAME_FIELD = 'DeveloperName';

    private VisualEditor.DesignTimePageContext context;

    global AiSummaryPromptsFilterByObject(VisualEditor.DesignTimePageContext context) {
        this.context = context;
    }

    global override VisualEditor.DataRow getDefaultValue() {
        List<Option> options = getPromptTemplates(context?.entityName);
        if (!options.isEmpty()) {
            return new VisualEditor.DataRow(options[0].label, options[0].value);
        }
        return null;
    }

    global override VisualEditor.DynamicPickListRows getValues() {
        VisualEditor.DynamicPickListRows rows = new VisualEditor.DynamicPickListRows();
        for (Option opt : getPromptTemplates(context?.entityName)) {
            rows.addRow(new VisualEditor.DataRow(opt.label, opt.value));
        }
        return rows;
    }

    public static List<Option> getPromptTemplates(String inputObjectApiName) {
        List<Option> results = new List<Option>();
        Integer page = 0;
        Boolean hasMoreRecords = true;

        do {
            ConnectApi.EinsteinPromptRecordCollectionOutputRepresentation result =
                ConnectApi.EinsteinLLM.getPromptTemplates(null, null, page, 50, new List<String>{RELATED_ENTITY_FIELD}, PROMPT_TEMPLATE_TYPE, null, true);

            hasMoreRecords = result?.hasMoreRecords == true;
            if (result?.promptRecords == null) break;

            for (ConnectApi.EinsteinPromptRecordRepresentation record : result.promptRecords) {
                String objectApiName = (String) record.fields?.get(RELATED_ENTITY_FIELD)?.value;
                Boolean isActive = (Boolean) record.fields?.get(IS_ACTIVE_FIELD)?.value;
                if (objectApiName != null && objectApiName.equalsIgnoreCase(inputObjectApiName) && isActive == true) {
                    String label = (String) record.fields?.get(MASTER_LABEL_FIELD)?.value;
                    String devName = (String) record.fields?.get(DEVELOPER_NAME_FIELD)?.value;
                    results.add(new Option(label, devName));
                }
            }
            page++;
        } while (hasMoreRecords);

        return results;
    }

    public class Option {
        public Option(String label, String value) {
            this.label = label;
            this.value = value;
        }
        public final String label;
        public final String value;
    }
}
