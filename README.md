# Training IRIS For Health

# Prerequisites :

* VSCode
  * Install VSCode : https://code.visualstudio.com/
  * Install the VsCode addon suite for InterSystems : https://intersystems-community.github.io/vscode-objectscript/installation/
* Docker
  * Intall Docker : https://docs.docker.com/get-docker/
* Git
  * Install git : https://git-scm.com/downloads

# Objective :

The objective of this training is to learn the InterSystems interoperability framework, in particular its health components 

# The framework :

![Framework](https://raw.githubusercontent.com/grongierisc/formation-template/master/misc/img/Framework.png)
 
All these components together form a production.
The arrows between the components are **messages**.

# Our first connector

During this guide we will be working mainly on this HL7v2 message :

```hl7
MSH|^~\&|XPLORE|PPR|ORBIS|ORBIS|201809121548||SIU^S14|A25335484220154822|P|2.3.1||||||8859/1
SCH||A25335451569||||^APT|||||^^^201809121548|||||4827^SMITH^JOHN|||^^^8712&EM Neuro Pédiatrie PPR&L|CSCHIR^^||^^^PPR&Hôpital Pierre-Paul Riquet&L|||STARTED|R171128-00000181^ORBIS|A25335451569
NTE|1||Priority: S, test|GI
PID|||031570943^^^CNV^PI||TESTBPE^BIO|TESTBPE|20100101|M|||^^^^||||||||
PV1||C|9231||||4827^SMITH^JOHN|9383^DOE^MARY||PPR|||||||||539622843
RGS|1|U
AIS|1|U|SCANCEA^RDV_CHU^EDL^^RDV_CH|201809120815|||35|MIN
```

## Create HL7_TCP_IN


## Les productions :

Créer notre première production :

![Production](https://raw.githubusercontent.com/grongierisc/formation-template/master/misc/img/Production.gif)


## Les opérations :

Maintenant que notre première production est créée nous aller passer aux opérations.
L’objectif de cette opération va être de sauvegarder dans IRIS le contenu d’un message.

1.	Créer la classe de stockage.
Les classes de stockage dans IRIS sont de type %Persistent

```objectscript
Class Formation.Table.Formation Extends %Persistent
{

Property Name As %String;

Property Salle As %String;

}

```
2.	Créer le message d’action sur l’opération
Le message contiendra un objet Formation :

```objectscript
Class Formation.Obj.Formation Extends (%SerialObject, %XML.Adaptor)
{

Property Nom As %String;

Property Salle As %String;

}
```
La classe Message qui contient l'objet formation :
```objectscript
Class Formation.Msg.FormationInsertRequest Extends Ens.Request
{

Property Formation As Formation.Obj.Formation;

}
```
3.	L’opération :

```objectscript
Class Formation.BO.LocalBDD Extends Ens.BusinessOperation
{

Parameter INVOCATION = "Queue";

Method InsertLocalBDD(pRequest As Formation.Msg.FormationInsertRequest, Output pResponse As Ens.StringResponse) As %Status
{
    set tStatus = $$$OK
    
    try{
        set pResponse = ##class(Ens.Response).%New()
        set tFormation = ##class(Formation.Table.Formation).%New()
        set tFormation.Name = pRequest.Formation.Nom
        set tFormation.Salle = pRequest.Formation.Salle
        $$$ThrowOnError(tFormation.%Save())
    }
    catch exp
    {
        Set tStatus = exp.AsStatus()
    }

    Quit tStatus
}

XData MessageMap
{
<MapItems>
    <MapItem MessageType="Formation.Msg.FormationInsertRequest"> 
        <Method>InsertLocalBDD</Method>
    </MapItem>
</MapItems>
}

}

```

Ajouter l'opération à la production :

![BO](https://raw.githubusercontent.com/grongierisc/formation-template/master/misc/img/InstanceOperation.gif)

Tester l'opération :

![Test](https://raw.githubusercontent.com/grongierisc/formation-template/master/misc/img/TestBO.gif)

## Les Business Process :

Les business process sont les règles métiers d’un flux.

Créer son premier business process :

![BP](https://raw.githubusercontent.com/grongierisc/formation-template/master/misc/img/BusinessProcess.gif)

Ajoutons maintenant l'appel au BO avec le message construit précédemment

![BuildBP](https://raw.githubusercontent.com/grongierisc/formation-template/master/misc/img/BuildBP.gif)

Ce BP peut etre instancié dans la production comme pour les BO et etre testé.

Ici, il s'agit d'un simple passe plat. Nous allons le complexifier afin qu'il puisse prendre en entrée une ligne d'un fichier CSV.

### Creer un recard map

Un record map est le mapping d'un fichier vers un object.

Creer un record map :

![RecordMapCsv](https://raw.githubusercontent.com/grongierisc/formation-template/master/misc/img/RecordMapCsv.gif)

Maintenant que le record map est crée nous allons creer une transformation entre le format des record maps et les messages d'insertion en BDD.

### Creer une data transformation

![CreateDT](https://raw.githubusercontent.com/grongierisc/formation-template/master/misc/img/CreateDT.gif)

La data transformation créée, nous pouvons mapper les champs :

![MapDT](https://raw.githubusercontent.com/grongierisc/formation-template/master/misc/img/MapDT.gif)

Revenons au Business Process pour y ajouter notre DT.

![AddDTtoBP](https://raw.githubusercontent.com/grongierisc/formation-template/master/misc/img/AddDTtoBP.gif)

Ici, la première action réalisée est de modifier l'entrée du BP pour qu'il puisse acceuillir le Recard Map, ensuite nous ajoutons la transforamtion.

Passons à la configuration de cette transforamtion :

Nous commencons par l'ajout du message à envoyer au BO dans le **context** du BP.

![AddMsgToContext](https://raw.githubusercontent.com/grongierisc/formation-template/master/misc/img/AddMsgToContext.gif)

Ensuite nous configurons la transformation :

![DTtoCallInBP](https://raw.githubusercontent.com/grongierisc/formation-template/master/misc/img/DTtoCallInBP.gif)

1. L'entrée de la DT est le message d'entré du business process (request)
2. La sortie de la DT est le message dans le context qui sera transmis à l'appel
3. Nous supprimons l'ancien mapping par l'appel contextuel

Le nouveau BP est pret, configurons le tout dans la production :

![AddBPandServiceProd](https://raw.githubusercontent.com/grongierisc/formation-template/master/misc/img/AddBPandServiceProd.gif)

1. Peu de configuration pour le BP
2. Pour le record map, nous utilisons un service générique qui est configuré pour utiliser le record map

![ConfigureRMinProd](https://raw.githubusercontent.com/grongierisc/formation-template/master/misc/img/ConfigureRMinProd.gif)

Test le flux de bout en bout :

![TestProdRMEndToEnd](https://raw.githubusercontent.com/grongierisc/formation-template/master/misc/img/TestProdRMEndToEnd.gif)

## Accèder à une base de données externe en JDBC

Pour accèder à une base de données externe nous allons utiliser le protocle JDBC et l'adapter SQL d'ensemble.

Créer l'opération suivante :

```objectscript
Include EnsSQLTypes

Class Formation.BO.RemoteBDD Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method InsertRemoteBDD(pRequest As Formation.Msg.FormationInsertRequest, Output pResponse As Ens.StringResponse) As %Status
{
	set tStatus = $$$OK
	
	try{
		set pResponse = ##class(Ens.Response).%New()
		set ^inc = $I(^inc)
		set tInsertSql = "INSERT INTO public.formation (id, nom, salle) VALUES(?, ?, ?)"
		$$$ThrowOnError(..Adapter.ExecuteUpdate(.nrows,tInsertSql,^inc,pRequest.Formation.Nom, pRequest.Formation.Salle ))
	}
	catch exp
	{
		Set tStatus = exp.AsStatus()
	}

	Quit tStatus
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="Formation.Msg.FormationInsertRequest"> 
		<Method>InsertRemoteBDD</Method>
	</MapItem>
</MapItems>
}

}
```

Nous pouvons remarquer que cette opération utilise le même message que l'opération d'insertion en local.

Instancier l'opération :

![AddRemoteBDD](https://raw.githubusercontent.com/grongierisc/formation-template/master/misc/img/AddRemoteBDD.gif)

Ajouter la JavaGateway pour le driver JDBC :

![AddJG](https://raw.githubusercontent.com/grongierisc/formation-template/master/misc/img/AddJG.gif)

Configurer l'opération :

![ConfigJDBC](https://raw.githubusercontent.com/grongierisc/formation-template/master/misc/img/ConfigJDBC.gif)

Configurer les credentials :

![Credential](https://raw.githubusercontent.com/grongierisc/formation-template/master/misc/img/Credential.gif)

Test la configuration en ajoutant le JavaGateway à l'opération :

![JGPlusTestJDBC](https://raw.githubusercontent.com/grongierisc/formation-template/master/misc/img/JGPlusTestJDBC.gif)

## Creer un service Rest

Pour creer un service rest, il faut une classe qui hérite de %CSP.REST :

```objectscript
Class Formation.REST.Dispatch Extends %CSP.REST
{

/// Ignore any writes done directly by the REST method.
Parameter IgnoreWrites = 0;

/// By default convert the input stream to Unicode
Parameter CONVERTINPUTSTREAM = 1;

/// The default response charset is utf-8
Parameter CHARSET = "utf-8";

Parameter HandleCorsRequest = 1;

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
  <!-- Get this spec -->
  <Route Url="/import" Method="post" Call="import" />
</Routes>
}

/// Get this spec
ClassMethod import() As %Status
{
  set tSc = $$$OK

  Try {

      set tBsName = "Formation.BS.RestInput"
      set tMsg = ##class(Formation.Msg.FormationInsertRequest).%New()

      set body = $zcvt(%request.Content.Read(),"I","UTF8")
      set dyna = {}.%FromJSON(body)

      set tFormation = ##class(Formation.Obj.Formation).%New()
      set tFormation.Nom = dyna.nom
      set tFormation.Salle = dyna.salle

      set tMsg.Formation = tFormation
      
      $$$ThrowOnError(##class(Ens.Director).CreateBusinessService(tBsName,.tService))
      
      $$$ThrowOnError(tService.ProcessInput(tMsg,.output))

  } Catch ex {
      set tSc = ex.AsStatus()
  }

  Quit tSc
}

}
```

Cette classe contient une route import avec le verbe POST lié à la méthode import :

```xml
<Routes>
  <!-- Get this spec -->
  <Route Url="/import" Method="post" Call="import" />
</Routes>
```

La méthode import creer un nouveau message à destination d'un BS.

Classe du BS REST, c'est une classe générique qui route toutes ses solicitations vers TargetConfigNames qui sera configuré lors de son instanciation 

```objectscript
Class Formation.BS.RestInput Extends Ens.BusinessService
{

Property TargetConfigNames As %String(MAXLEN = 1000) [ InitialExpression = "BuisnessProcess" ];

Parameter SETTINGS = "TargetConfigNames:Basic:selector?multiSelect=1&context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId}";

Method OnProcessInput(pDocIn As %RegisteredObject, Output pDocOut As %RegisteredObject) As %Status
{
    set status = $$$OK

    try {

        for iTarget=1:1:$L(..TargetConfigNames, ",") {
		    set tOneTarget=$ZStrip($P(..TargetConfigNames,",",iTarget),"<>W")  Continue:""=tOneTarget
		    $$$ThrowOnError(..SendRequestSync(tOneTarget,pDocIn,.pDocOut))
	    }
    } catch ex {
        set status = ex.AsStatus()
    }

    Quit status
}

}
```

Instanciation du BS :

![ConfigurationBSRest](https://raw.githubusercontent.com/grongierisc/formation-template/master/misc/img/ConfigurationBSRest.gif)

Publication du service REST :

![ConfigurationDiscpatch](https://raw.githubusercontent.com/grongierisc/formation-template/master/misc/img/ConfigurationDiscpatch.gif)

Tester le nouveau service :

![TestRESTOperation](https://raw.githubusercontent.com/grongierisc/formation-template/master/misc/img/TestRESTOperation.gif)
