public class hd_XmlFactory {
    private final string TEXT_TYPE = 'TE';
    private final string DATE_TYPE = 'DA';
    private final string MULTIPLE_CHOICE = 'MC';
    private final string BOOL_TYPE = 'TF';
    private final string NUMBER_TYPE = 'NU';

    private DOM.Document doc;
    private DOM.XmlNode root;

    public hd_XmlFactory() {
        doc = new DOM.Document();
        root = doc.createRootElement('AnswerSet', null, null);
        root.setAttribute('title', '');
    }

    public DOM.Document GetDoc() {
        return doc;
    }

    public DOM.XmlNode AddAnswerNode(string name, object value) {
        return AddAnswerNode(name, new List<object> { value }, false);
    }

    public DOM.XmlNode AddAnswerNode(string name, List<object> values, boolean repeats) {
        String ansType = getAnswerType(name);
        DOM.XmlNode holdsValues;

        DOM.XmlNode node = addAnswer(name);
        if (values == null) {
            values = new List<object> { null };
        }
        
        if (repeats) {
            holdsValues = node.addChildElement('RptValue', null, null);
        } else {
            holdsValues = node;
        }

        for (object value : values) {
            appendValueNode(holdsValues, value, ansType);
        }        

        return node;        
    }

    private void appendValueNode(DOM.XmlNode node, object value, string ansType) {
        if (ansType == TEXT_TYPE) {
            addTextValue(node, String.valueOf(value));

        } else if (ansType == NUMBER_TYPE) {
            addNumValue(node, (Decimal)value);

        } else if (ansType == DATE_TYPE) {
            addDateValue(node, (DateTime)value);

        } else if (ansType == BOOL_TYPE) {
            addTFValue(node, (Boolean)value);

        } else if (ansType == MULTIPLE_CHOICE) {
            addMCValue(node, (String)value);
        } else {
            addTextValue(node, null);
        }
    }

    private void addMCValue(DOM.XmlNode node, string value) {
        DOM.XmlNode mc = node.addChildElement('MCValue', null, null);
        DOM.XmlNode sel = mc.addChildElement('SelValue', null, null);

        if (value == '' || value == null) {
            mc.setAttribute('unans', 'true');
        } else {
            sel.addTextNode(value);
        }
    }

    private void addTextValue(DOM.XmlNode node, string value) {
        DOM.XmlNode text = node.addChildElement('TextValue', null, null);

        if (value == '' || value == null) {
            text.setAttribute('unans', 'true');
        } else {
            text.addTextNode(value);
        }
    }

    private void addNumValue(DOM.XmlNode node, Decimal value) {
        DOM.XmlNode text = node.addChildElement('NumValue', null, null);

        if (value == null) {
            text.setAttribute('unans', 'true');
        } else {
            text.addTextNode(String.valueOf(value));
        }
    }

    private void addDateValue(DOM.XmlNode node, DateTime value) {
        DOM.XmlNode text = node.addChildElement('DateValue', null, null);

        if (value == null) {
            text.setAttribute('unans', 'true');
        } else {
            text.addTextNode(
                String.valueOf(value.dayGmt()) + '/' +
                String.valueOf(value.monthGmt()) + '/' +
                String.valueOf(value.yearGmt()));
        }
    }

    private void addTFValue(Dom.XmlNode node, Boolean value) {
        DOM.XmlNode text = node.addChildElement('TFValue', null, null);

        if (value == null) {
            text.setAttribute('unans', 'true');
        } else {
            text.addTextNode(value ? 'true' : 'false');
        }
    }

    private DOM.XmlNode addAnswer(string name) {
        DOM.XmlNode node = root.addChildElement('Answer', null, null);
        node.setAttribute('name', name);
        return node;
    }

    private String getAnswerType(string name) {
        return name.right(2);
    }
}