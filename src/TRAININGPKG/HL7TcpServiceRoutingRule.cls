/// 
Class TRAININGPKG.HL7TcpServiceRoutingRule Extends Ens.Rule.Definition
{

Parameter RuleAssistClass = "EnsLib.HL7.MsgRouter.RuleAssist";

XData RuleDefinition [ XMLNamespace = "http://www.intersystems.com/rule" ]
{
<ruleDefinition alias="TRAININGPKG.HL7_Tcp_ServiceRoutingRule" context="EnsLib.HL7.MsgRouter.RoutingEngine" production="TRAININGPKG.FoundationProduction">
<ruleSet name="" effectiveBegin="" effectiveEnd="">
<rule name="">
<when condition="1">
<send transform="Training.DTL.SIU.AIStoSCH" target="HL7_File_Operation"></send>
<return></return>
</when>
</rule>
</ruleSet>
</ruleDefinition>
}

}
