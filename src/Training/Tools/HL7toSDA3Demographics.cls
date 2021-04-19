/// Description
Class Training.Tools.HL7toSDA3Demographics Extends HS.Hub.Standalone.HL7.HL7ToSDA3
{

ClassMethod GetTransformClass(msgType As %String, ByRef pTransformClass As %String) As %Status
{
	set tSC=$$$OK
	
	set pTransformClass=..OnGetTransformClass() 
	quit:pTransformClass'=""	
	
	set pTransformClass = $CASE(msgType,
              "ADT_A01":"ADTA01ToSDA3", "ADT_A02":"ADTA02ToSDA3", "ADT_A03":"ADTA03ToSDA3",
              "ADT_A04":"ADTA01ToSDA3", "ADT_A05":"ADTA05ToSDA3", "ADT_A06":"ADTA01ToSDA3",
              "ADT_A07":"ADTA01ToSDA3", "ADT_A08":"ADTA01ToSDA3", "ADT_A09":"ADTA01ToSDA3",
              "ADT_A10":"ADTA01ToSDA3", "ADT_A11":"ADTA09ToSDA3", "ADT_A12":"ADTA01ToSDA3",
              "ADT_A13":"ADTA01ToSDA3", "ADT_A16":"ADTA01ToSDA3", "ADT_A17":"ADTA01ToSDA3",
              "ADT_A18":"ADTA18ToSDA3", "ADT_A23":"ADTA21ToSDA3", "ADT_A25":"ADTA01ToSDA3",
              "ADT_A27":"ADTA01ToSDA3", "ADT_A28":"ADTA05ToSDA3", "ADT_A29":"ADTA21ToSDA3",
              "ADT_A30":"ADTA30ToSDA3", "ADT_A31":"ADTA05ToSDA3", "ADT_A34":"ADTA30ToSDA3",
              "ADT_A36":"ADTA30ToSDA3", "ADT_A39":"ADTA40ToSDA3", "ADT_A40":"ADTA40ToSDA3",
              "ADT_A45":"ADTA45ToSDA3", "ADT_A47":"ADTA30ToSDA3", "ADT_A50":"ADTA50ToSDA3",
              "ADT_A60":"ADTA60ToSDA3", "BAR_P12":"BARP12ToSDA3", "MDM_T02":"MDMT02ToSDA3",
              "MDM_T04":"MDMT02ToSDA3", "MDM_T08":"MDMT02ToSDA3", "MDM_T11":"MDMT01ToSDA3",
              "OMP_O09":"OMPO09ToSDA3", "ORM_O01":"ORMO01ToSDA3", "ORU_R01":"ORUR01ToSDA3",
              "PPR_PC1":"PPRPC1ToSDA3", "PPR_PC2":"PPRPC1ToSDA3", "PPR_PC3":"PPRPC1ToSDA3",
              "RDE_O11":"RDEO11ToSDA3", "SIU_S12":"SIUS12ToSDA3", "SIU_S13":"SIUS12ToSDA3",
              "SIU_S14":"SIUS12ToSDA3", "SIU_S15":"SIUS12ToSDA3", "SIU_S16":"SIUS12ToSDA3",
              "SIU_S17":"SIUS12ToSDA3", "SIU_S26":"SIUS12ToSDA3", "VXU_V04":"VXUV04ToSDA3",
              :"Unsupported HL7 Message Type")

	set:pTransformClass="Unsupported HL7 Message Type" tSC = $$$HSError($$$HSErrUnsupportedHL7MessageType,msgType)
 	if $$$ISERR(tSC) quit tSC
 	
 	set tTransformPackage = "HS.Hub.Standalone.HL7.DTL"
 	set pTransformClass = tTransformPackage_"."_pTransformClass
	
	quit tSC
}

}
