Class Training.Tools.HL7toSDA3Full Extends HS.Gateway.HL7.HL7ToSDA3
{

ClassMethod GetSDA(pRequest As EnsLib.HL7.Message, Output pXML As %Stream.GlobalCharacter, pLogAlerts As %Boolean = 1, pObservationMode As %Boolean = 0, pMultiLineOBXCompatibilityMode As %Boolean = 0, pKeepDuplicateOBXIdentifiers As %Boolean = 0) As %Status
{
  set sc = ##super(pRequest,.pXML,pLogAlerts,pObservationMode,pMultiLineOBXCompatibilityMode,pKeepDuplicateOBXIdentifiers) 
  kill ^HS.Data
  merge ^HS.Data=^||HS.Data
  quit sc
}

}
