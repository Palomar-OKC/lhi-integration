@isTest
public class hd_XmlFactoryTest {
    private static hd_XmlFactory init() {
        return new hd_XmlFactory();
    }

    public static testmethod void InitializesAnswerSet() {
        DOM.Document doc = init().getDoc();

        System.assertEquals(doc.getRootElement().getAttribute('title', null),'');
        System.assertEquals(doc.getRootElement().getName(),'AnswerSet');
    }

    public static testmethod void ReturnsTextNode() {
        Dom.XmlNode result = init().AddAnswerNode('node name TE', 'node text');

        AssertStandards(result, 'node name TE');
        System.assertEquals(1, result.getChildren().size());
        System.assertEquals('TextValue', result.getChildren()[0].getName());
        System.assertEquals('node text', result.getChildren()[0].getText());
    }

    public static testmethod void SetsNullValueForNoAnswer_Text() {
        Dom.XmlNode result = init().AddAnswerNode('node name TE', '');

        AssertStandards(result, 'node name TE');
        System.assertEquals('true',result.getChildren()[0].getAttribute('unans', null));
    }

    public static testmethod void SetsNullForNullAnswer_Text() {
        Dom.XmlNode result = init().AddAnswerNode('node name TE', null);

        AssertStandards(result, 'node name TE');
        System.assertEquals('true',result.getChildren()[0].getAttribute('unans', null));
    }

    public static testmethod void ReturnsNumNode() {
        Dom.XmlNode result = init().AddAnswerNode('node name NU', 1);

        AssertStandards(result, 'node name NU');
        System.assertEquals(1, result.getChildren().size());
        System.assertEquals('NumValue', result.getChildren()[0].getName());
        System.assertEquals('1', result.getChildren()[0].getText());
    }

    public static testmethod void ReturnsDateNode() {
        Dom.XmlNode result = init().AddAnswerNode('node name DA', Date.newInstance(1990,12,30));

        AssertStandards(result, 'node name DA');
        System.assertEquals(1, result.getChildren().size());
        System.assertEquals('DateValue', result.getChildren()[0].getName());
        System.assertEquals('30/12/1990', result.getChildren()[0].getText());
    }

    public static testmethod void ReturnsTFNode() {
        Dom.XmlNode result = init().AddAnswerNode('node name TF', true);

        AssertStandards(result, 'node name TF');
        System.assertEquals(1, result.getChildren().size());
        System.assertEquals('TFValue', result.getChildren()[0].getName());
        System.assertEquals('true', result.getChildren()[0].getText());
    }

    public static testmethod void ReturnsMCNode() {
        Dom.XmlNode result = init().AddAnswerNode('node name MC', 'mc value');

        AssertStandards(result, 'node name MC');
        System.assertEquals(1, result.getChildren().size());
        System.assertEquals('MCValue', result.getChildren()[0].getName());
        System.assertEquals(1, result.getChildren()[0].getChildren().size());
        System.assertEquals('SelValue',result.getChildren()[0].getChildren()[0].getName());
        System.assertEquals('mc value', result.getChildren()[0].getChildren()[0].getText());
    }

    public static testmethod void ReturnsEmptyMCNode() {
        Dom.XmlNode result = init().AddAnswerNode('node name MC', '');

        AssertStandards(result, 'node name MC');
        System.assertEquals(1, result.getChildren().size());
        System.assertEquals('MCValue', result.getChildren()[0].getName());
        System.assertEquals('true', result.getChildren()[0].getAttribute('unans', null));
        System.assertEquals(1, result.getChildren()[0].getChildren().size());
        System.assertEquals('SelValue',result.getChildren()[0].getChildren()[0].getName());
    }

    public static testmethod void ReturnsNullMCNode() {
        Dom.XmlNode result = init().AddAnswerNode('node name MC', null);

        AssertStandards(result, 'node name MC');
        System.assertEquals(1, result.getChildren().size());
        System.assertEquals('MCValue', result.getChildren()[0].getName());
        System.assertEquals('true', result.getChildren()[0].getAttribute('unans', null));
        System.assertEquals(1, result.getChildren()[0].getChildren().size());
        System.assertEquals('SelValue',result.getChildren()[0].getChildren()[0].getName());
    }

    public static testmethod void ReturnsRPTNode_One() {
        Dom.XmlNode result = init().AddAnswerNode('node name TE', new List<string> { 'test' }, true);

        AssertStandards(result, 'node name TE');
        System.assertEquals(1, result.getChildren().size());
        System.assertEquals('RptValue', result.getChildren()[0].getName());
        System.assertEquals(1, result.getChildren()[0].getChildren().size());
        System.assertEquals('TextValue',result.getChildren()[0].getChildren()[0].getName());
        System.assertEquals('test', result.getChildren()[0].getChildren()[0].getText());
    }

    public static testmethod void ReturnsRptNode_Many() {
        Dom.XmlNode result = init().AddAnswerNode('node name TE', new List<string> { 'first', 'second' }, true);

        AssertStandards(result, 'node name TE');
        System.assertEquals(1, result.getChildren().size());
        System.assertEquals('RptValue', result.getChildren()[0].getName());
        System.assertEquals(2, result.getChildren()[0].getChildren().size());
        
        System.assertEquals('TextValue',result.getChildren()[0].getChildren()[0].getName());
        System.assertEquals('first', result.getChildren()[0].getChildren()[0].getText());

        System.assertEquals('TextValue',result.getChildren()[0].getChildren()[1].getName());
        System.assertEquals('second', result.getChildren()[0].getChildren()[1].getText());
    }

    public static testmethod void ReturnsRPTNode_Unans() {
        Dom.XmlNode result = init().AddAnswerNode('node name TE', null, true);

        AssertStandards(result, 'node name TE');
        System.assertEquals(1, result.getChildren().size());
        System.assertEquals('RptValue', result.getChildren()[0].getName());
        System.assertEquals(1, result.getChildren()[0].getChildren().size());
        System.assertEquals('TextValue',result.getChildren()[0].getChildren()[0].getName());
        System.assertEquals('true', result.getChildren()[0].getChildren()[0].getAttribute('unans', null));
    }

    private static void AssertStandards(DOM.XmlNode result, string name) {
        System.assertEquals('Answer', result.getName());
        System.assertEquals(name, result.getAttribute('name', null));
    }
}