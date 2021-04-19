Class Training.DTL.SIU.AIStoSCH Extends Ens.DataTransformDTL [ DependsOn = EnsLib.HL7.Message ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.HL7.Message' targetClass='EnsLib.HL7.Message' sourceDocType='2.5.1:SIU_S12' targetDocType='2.5.1:SIU_S12' create='copy' language='objectscript' >
<assign value='source.{RGSgrp().AISgrp().AIS:Duration}' property='target.{SCH:AppointmentDuration}' action='set' />
<assign value='source.{RGSgrp().AISgrp().AIS:DurationUnits}' property='target.{SCH:AppointmentDurationUnits}' action='set' />
</transform>
}

}
