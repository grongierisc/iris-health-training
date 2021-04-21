/// Description
Class Training.BP.SDA3toHL7 Extends Ens.BusinessProcess
{

Method OnRequest(pRequest As Ens.Request, Output pResponse As Ens.Response) As %Status
{
    set sc = $$$OK

    Try {
        //Cast the SDA Stream as an XML Document
        set tVDoc= ##class(EnsLib.EDI.XML.Document).ImportFromString(pRequest.ContentStream, .sc)
        //Transform it as un ADT
        do ##class(HS.Gateway.SDA3.SDA3ToHL7.ADTA0N).Transform(tVDoc,.tHL7)
        //Send the tHL7 Message
        set sc = ..SendRequestSync("HL7_File_Operation",tHL7,.pResponse)
        if '$ISOBJECT(pResponse){
            set pResponse = ##class(HS.FHIRServer.Interop.Response).%New()
        }
    }
    Catch ex {
        Set sc=ex.AsStatus()
    }

    Quit sc
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
