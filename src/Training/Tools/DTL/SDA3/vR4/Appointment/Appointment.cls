Class Training.Tools.DTL.SDA3.vR4.Appointment.Appointment Extends Ens.DataTransformDTL [ DependsOn = (HS.SDA3.Appointment, HS.FHIR.DTL.vR4.Model.Resource.Appointment) ]
{

Parameter IGNOREMISSINGSOURCE = 0;

Parameter REPORTERRORS = 0;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.SDA3.Appointment' targetClass='HS.FHIR.DTL.vR4.Model.Resource.Appointment' create='existing' language='objectscript' >
<annotation> Transforms HS.SDA3.Appointment (SDA3) to Appointment (vR4) </annotation>
<code disabled='1' >
<![CDATA[ set schema = ##class(HS.FHIRServer.Schema).LoadSchema("R4") 
 set aux("transformer") = ##class(HS.FHIR.DTL.Util.API.Transform.SDA3ToFHIR).%New(schema)]]></code>
<if condition='source.NoShow = 1' >
<true>
<assign value='"noshow"' property='target.status' action='set' >
<annotation> proposed | pending | booked | arrived | fulfilled | cancelled | noshow | entered-in-error | checked-in | waitlist
 --- This mapping entry assigns a literal value to a target field. A field-to-field mapping to this target field also exists. Be aware that literal value mappings execute first, then field-to-field mappings. The result is that if any field-to-field mapping is non-empty, it will overwrite any literal value mapped to the same target field. If this is not the desired result, the Condition to Set This Field for mappings to this target field must coordinate conditions to ensure that the literal value takes precedence when it should.   </annotation>
</assign>
</true>
</if>
<assign value='##class(HS.FHIR.DTL.Util.SDA3.Handler.CustomPairs).Extension(source.CustomPairs, .target, .aux)' property='value' action='set' />
<assign value='target.extension.Count()+1' property='index' action='set' />
<if condition='value&apos;=""' >
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/appointment-custom-pairs"' property='value.url' action='set' />
<assign value='value' property='target.extension' action='set' key='index' >
<annotation> Additional content defined by implementations
 --- When the SDA3 source data contains a CustomPairs collection, and the target is FHIR, the collection is mapped to a FHIR extension that contains a Parameters resource. This Parameters resource is a collection of paired fields: name and valueString.   </annotation>
</assign>
</true>
</if>
<assign value='##class(HS.FHIR.DTL.Util.SDA3.Handler.Appointment).Patient(.aux)' property='value' action='set' />
<assign value='target.participant.Count()+1' property='index' action='set' />
<if condition='value&apos;=""' >
<true>
<assign value='value' property='target.participant' action='set' key='index' >
<annotation> Participants involved in appointment </annotation>
</assign>
</true>
</if>
<if condition='##class(HS.FHIR.DTL.Util.Element.Object).Defined(source, "CareProvider")' >
<true>
<assign value='##class(HS.FHIR.DTL.Util.SDA3.Handler.Appointment).participant(source.CareProvider, .target, .aux)' property='value' action='set' />
<assign value='target.participant.Count()+1' property='index' action='set' />
<if condition='value&apos;=""' >
<true>
<assign value='value' property='target.participant' action='set' key='index' >
<annotation> Participants involved in appointment
Note: default participant status will be &quot;accepted&quot; </annotation>
</assign>
</true>
</if>
</true>
</if>
<if condition='source.EncounterNumber&apos;=""' >
<true>
<assign value='target.extension.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vR4.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.EncounterNumber, "HS.FHIR.DTL.SubXFrm.SDA3.vR4.String.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""' >
<true>
<assign value='$classmethod(DTL, "Transform", source.EncounterNumber, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""' >
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/appointment-encounter-number"' property='tmp.url' action='set' />
<assign value='tmp' property='target.extension' action='set' key='index' >
<annotation> Additional content defined by implementations </annotation>
</assign>
</true>
</if>
</true>
</if>
</true>
</if>
<if condition='##class(HS.FHIR.DTL.Util.Element.Object).Defined(source, "EnteredAt")' >
<true>
<assign value='target.extension.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vR4.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.EnteredAt, "HS.FHIR.DTL.SDA3.vR4.CodeTableDetail.Organization.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""' >
<true>
<assign value='$classmethod(DTL, "Transform", source.EnteredAt, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""' >
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/appointment-entered-at"' property='tmp.url' action='set' />
<assign value='tmp' property='target.extension' action='set' key='index' >
<annotation> Additional content defined by implementations </annotation>
</assign>
</true>
</if>
</true>
</if>
</true>
</if>
<if condition='##class(HS.FHIR.DTL.Util.Element.Object).Defined(source, "EnteredBy")' >
<true>
<assign value='target.extension.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vR4.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.EnteredBy, "HS.FHIR.DTL.SDA3.vR4.CodeTableDetail.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""' >
<true>
<assign value='$classmethod(DTL, "Transform", source.EnteredBy, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""' >
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/appointment-entered-by"' property='tmp.url' action='set' />
<assign value='tmp' property='target.extension' action='set' key='index' >
<annotation> Additional content defined by implementations </annotation>
</assign>
</true>
</if>
</true>
</if>
</true>
</if>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).DateToFHIR(source.EnteredOn, "dateTime")' property='value' action='set' />
<if condition='value&apos;=""' >
<true>
<assign value='value' property='target.created' action='set' >
<annotation> The date that this appointment was initially created </annotation>
</assign>
</true>
</if>
<assign value='##class(HS.FHIR.DTL.Util.SDA3.Handler.ExternalId).Identifier(source.ExternalId)' property='value' action='set' />
<assign value='target.identifier.Count()+1' property='index' action='set' />
<if condition='value&apos;=""' >
<true>
<assign value='value' property='target.identifier' action='set' key='index' >
<annotation> External Ids for this item </annotation>
</assign>
</true>
</if>
<assign value='##class(HS.FHIR.DTL.Util.Element.Object).StringToIdentifier(source.FillerApptId,"FillerApptId")' property='value' action='set' />
<assign value='target.identifier.Count()+1' property='index' action='set' />
<if condition='value&apos;=""' >
<true>
<assign value='value' property='target.identifier' action='set' key='index' >
<annotation> External Ids for this item </annotation>
</assign>
</true>
</if>
<if condition='source.FillerOrderId&apos;=""' >
<true>
<assign value='target.extension.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vR4.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.FillerOrderId, "HS.FHIR.DTL.SubXFrm.SDA3.vR4.String.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""' >
<true>
<assign value='$classmethod(DTL, "Transform", source.FillerOrderId, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""' >
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/appointment-filler-order-id"' property='tmp.url' action='set' />
<assign value='tmp' property='target.extension' action='set' key='index' >
<annotation> Additional content defined by implementations </annotation>
</assign>
</true>
</if>
</true>
</if>
</true>
</if>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).DateToFHIR(source.FromTime, "instant")' property='value' action='set' />
<if condition='value&apos;=""' >
<true>
<assign value='value' property='target.start' action='set' >
<annotation> When appointment is to take place </annotation>
</assign>
</true>
</if>
<if condition='((source.ToTime = "") &amp;&amp; (##class(HS.FHIR.DTL.Util.Lookup).Code("SDA3","vR4","HS.SDA3.Appointment:Status","appointmentstatus|4.0.1",source.Status) = "cancelled"))' >
<true>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).DateToFHIR(source.FromTime, "instant")' property='value' action='set' />
<if condition='value&apos;=""' >
<true>
<assign value='value' property='target.end' action='set' >
<annotation> When appointment is to conclude </annotation>
</assign>
</true>
</if>
</true>
</if>
<if condition='##class(HS.FHIR.DTL.Util.Element.Object).Defined(source, "Location")' >
<true>
<assign value='##class(HS.FHIR.DTL.Util.SDA3.Handler.Appointment).participant(source.Location, .target, .aux)' property='value' action='set' />
<assign value='target.participant.Count()+1' property='index' action='set' />
<if condition='value&apos;=""' >
<true>
<assign value='value' property='target.participant' action='set' key='index' >
<annotation> Participants involved in appointment </annotation>
</assign>
</true>
</if>
</true>
</if>
<if condition='source.NoShow&apos;=""' >
<true>
<assign value='target.extension.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vR4.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.NoShow, "HS.FHIR.DTL.SubXFrm.SDA3.vR4.Boolean.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""' >
<true>
<assign value='$classmethod(DTL, "Transform", source.NoShow, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""' >
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/appointment-no-show"' property='tmp.url' action='set' />
<assign value='tmp' property='target.extension' action='set' key='index' >
<annotation> Additional content defined by implementations </annotation>
</assign>
</true>
</if>
</true>
</if>
</true>
</if>
<if condition='source.Notes&apos;=""' >
<true>
<assign value='source.Notes' property='target.comment' action='set' >
<annotation> Additional comments </annotation>
</assign>
</true>
</if>
<if condition='##class(HS.FHIR.DTL.Util.Element.Object).Defined(source, "OrderItem")' >
<true>
<assign value='target.serviceType.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.OrderItem, "HS.FHIR.DTL.SDA3.vR4.CodeTableTranslated.CodeableConcept")' property='DTL' action='set' />
<if condition='DTL&apos;=""' >
<true>
<assign value='$classmethod(DTL, "Transform", source.OrderItem, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""' >
<true>
<assign value='tmp' property='target.serviceType' action='set' key='index' >
<annotation> The specific service that is to be performed during this appointment
 --- In this case, any FHIR4 code may be used; service-type shows Example codes, but you may use codes from any ValueSet. 
 --- SDA does not restrict code values to a particular set.    </annotation>
</assign>
</true>
</if>
</true>
</if>
</true>
</if>
<assign value='##class(HS.FHIR.DTL.Util.Element.Object).StringToIdentifier(source.PlacerApptId,"PlacerApptId")' property='value' action='set' />
<assign value='target.identifier.Count()+1' property='index' action='set' />
<if condition='value&apos;=""' >
<true>
<assign value='value' property='target.identifier' action='set' key='index' >
<annotation> External Ids for this item </annotation>
</assign>
</true>
</if>
<if condition='source.PlacerOrderId&apos;=""' >
<true>
<assign value='target.extension.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vR4.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.PlacerOrderId, "HS.FHIR.DTL.SubXFrm.SDA3.vR4.String.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""' >
<true>
<assign value='$classmethod(DTL, "Transform", source.PlacerOrderId, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""' >
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/appointment-placer-order-id"' property='tmp.url' action='set' />
<assign value='tmp' property='target.extension' action='set' key='index' >
<annotation> Additional content defined by implementations </annotation>
</assign>
</true>
</if>
</true>
</if>
</true>
</if>
<if condition='&apos;source.NoShow' >
<true>
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("SDA3","vR4","HS.SDA3.Appointment:Status","appointmentstatus|4.0.1",source.Status)' property='value' action='set' />
<if condition='value&apos;=""' >
<true>
<assign value='value' property='target.status' action='set' >
<annotation> proposed | pending | booked | arrived | fulfilled | cancelled | noshow | entered-in-error | checked-in | waitlist
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping. 
 --- If the mapping is SDA to FHIR, and the source field contains a non-empty value, then by convention there are two mapping entries for this source field. Both entries execute under the same Condition to Set this Field. One entry does the lookup to retrieve the value to assign to the target field. The other stores the original source field value in a FHIR extension.    </annotation>
</assign>
</true>
<false>
<assign value='"booked"' property='target.status' action='set' />
</false>
</if>
</true>
</if>
<if condition='source.Status&apos;=""' >
<true>
<if condition='(&apos;source.NoShow &amp;&amp; (##class(HS.FHIR.DTL.Util.Lookup).Code("SDA3","vR4","HS.SDA3.Appointment:Status","appointmentstatus|4.0.1",source.Status) = ""))' >
<true>
<assign value='target.extension.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vR4.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.Status, "HS.FHIR.DTL.SubXFrm.SDA3.vR4.String.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""' >
<true>
<assign value='$classmethod(DTL, "Transform", source.Status, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""' >
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/appointment-status"' property='tmp.url' action='set' />
<assign value='tmp' property='target.extension' action='set' key='index' >
<annotation> Additional content defined by implementations
 --- This mapping supports a related mapping that does a table lookup to match the incoming source value with a value to place in the target field. This mapping has the same Condition to Set this Field as the table lookup. If the lookup successfully finds a value for target field, this mapping stores the original source field value in a FHIR extension.    </annotation>
</assign>
</true>
</if>
</true>
</if>
</true>
</if>
</true>
</if>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).DateToFHIR(source.ToTime, "instant")' property='value' action='set' />
<if condition='value&apos;=""' >
<true>
<assign value='value' property='target.end' action='set' >
<annotation> When appointment is to conclude </annotation>
</assign>
</true>
</if>
<if condition='((source.FromTime = "") &amp;&amp; (##class(HS.FHIR.DTL.Util.Lookup).Code("SDA3","vR4","HS.SDA3.Appointment:Status","appointmentstatus|4.0.1",source.Status) = "cancelled"))' >
<true>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).DateToFHIR(source.ToTime, "instant")' property='value' action='set' />
<if condition='value&apos;=""' >
<true>
<assign value='value' property='target.start' action='set' >
<annotation> When appointment is to take place </annotation>
</assign>
</true>
</if>
</true>
</if>
<if condition='##class(HS.FHIR.DTL.Util.Element.Object).Defined(source, "Type")' >
<true>
<assign value='##class(HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.Type, "HS.FHIR.DTL.SDA3.vR4.CodeTableTranslated.CodeableConcept")' property='DTL' action='set' />
<if condition='DTL&apos;=""' >
<true>
<assign value='$classmethod(DTL, "Transform", source.Type, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""' >
<true>
<assign value='tmp' property='target.appointmentType' action='set' >
<annotation> The style of appointment or patient that has been booked in the slot (not service type)
 --- In this case, v2-0276 is the Preferred FHIR4 ValueSet for codes, but if you need to express meanings not found in v2-0276, you may use codes from any ValueSet. 
 --- SDA does not restrict code values to a particular set.    </annotation>
</assign>
</true>
</if>
</true>
</if>
</true>
</if>
<if condition='##class(%Dictionary.ClassDefinition).%ExistsId("HS.FHIR.DTL.Mapping.Extension.SDA3.vR4.Appointment.Appointment")' >
<true>
<code>
<![CDATA[  lock +^HS.FHIR.DTL("lock", "HS.FHIR.DTL.Mapping.Extension.SDA3.vR4.Appointment.Appointment") ]]></code>
<assign value='##class(HS.FHIR.DTL.Mapping.Extension.SDA3.vR4.Appointment.Appointment).Transform(source.Extension, .target, .aux)' property='target' action='set' />
<code>
<![CDATA[  lock -^HS.FHIR.DTL("lock", "HS.FHIR.DTL.Mapping.Extension.SDA3.vR4.Appointment.Appointment") ]]></code>
</true>
</if>
</transform>
}

}
