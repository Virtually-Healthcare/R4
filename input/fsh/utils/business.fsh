// Extensions
Alias: $conf             = http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation
Alias: $dar              = http://hl7.org/fhir/StructureDefinition/data-absent-reason
Alias: $minLength        = http://hl7.org/fhir/StructureDefinition/minLength
Alias: $pertainsToGoal   = http://hl7.org/fhir/StructureDefinition/resource-pertainsToGoal
Alias: $typeMS           = http://hl7.org/fhir/StructureDefinition/elementdefinition-type-must-support


// Inter-version extensions
Alias: $observationFocus = http://hl7.org/fhir/5.0/StructureDefinition/extension-Observation.focus
Alias: $instanceContent  = http://hl7.org/fhir/5.0/StructureDefinition/extension-ExampleScenario.instance.content
Alias: $verContent       = http://hl7.org/fhir/5.0/StructureDefinition/extension-ExampleScenario.instance.version.content
Alias: $verTitle         = http://hl7.org/fhir/5.0/StructureDefinition/extension-ExampleScenario.instance.version.title


// ExampleScenario RuleSets
RuleSet: ActorEntity(id, name, description)
* actor[+]
  * actorId = "{id}"
  * type = #entity
  * name = {name}
  * description = "{description}"

RuleSet: ActorPerson(id, name, description)
* actor[+]
  * actorId = "{id}"
  * type = #person
  * name = {name}
  * description = "{description}"

RuleSet: Instance_Empty(id, type, name, description)
* instance[+]
  * resourceId = "{id}"
  * resourceType = #{type}
  * name = {name}
  * description = "{description}"

RuleSet: Instance_Content(id, type, name, description)
* insert Instance_Empty({id}, {type}, {name}, [[{description}]])
* instance[=].extension[$instanceContent].valueReference = Reference({id})

RuleSet: InstanceVersion(id, name, content, description)
* instance[=].version[+]
  * extension[$verTitle].valueString = {name}
  * extension[$verContent].valueReference = Reference({content})
  * versionId = "{id}"
  * description = "{description}"

RuleSet: InstanceContains(id, version)
* instance[=].containedInstance
  * resourceId = "{id}"
  * versionId = "{version}"

RuleSet: ProcessSearch(num, name, sender, receiver, request, response, description)
* step[+].operation
  * number = "{num}"
  * type = "search-type"
  * name = {name}
  * description = "{description}"
  * initiator = "{sender}"
  * receiver = "{receiver}"
  * request.resourceId = "{request}"
  * response.resourceId = "{response}"

RuleSet: ProcessRead(num, name, sender, receiver, request, response, description)
* step[+].operation
  * number = "{num}"
  * type = "read"
  * name = {name}
  * description = "{description}"
  * initiator = "{sender}"
  * receiver = "{receiver}"
  * request.resourceId = "{request}"
  * response.resourceId = "{response}"

RuleSet: ProcessCreateEvent(num, name, sender, receiver, request, version, description)
* step[+].operation
  * number = "{num}"
  * type = "create"
  * name = {name}
  * description = "{description}"
  * initiator = "{sender}"
  * receiver = "{receiver}"
  * request.resourceId = "{request}"
  * request.versionId = "{version}"

RuleSet: ProcessCreate(num, name, sender, receiver, request, version, description)
* step[+].operation
  * number = "{num}"
  * type = "create"
  * name = {name}
  * description = "{description}"
  * initiator = "{sender}"
  * receiver = "{receiver}"
  * request.resourceId = "{request}"
  * request.versionId = "{version}"

RuleSet: ProcessUpdate(num, name, sender, receiver, request, version, description)
* step[+].operation
  * number = "{num}"
  * type = "update"
  * name = {name}
  * description = "{description}"
  * initiator = "{sender}"
  * receiver = "{receiver}"
  * request.resourceId = "{request}"
  * request.versionId = "{version}"

RuleSet: SubNotification(parameters, endpointPrefix, subscriptionId)
* entry
  * fullUrl = "http://example.org/fhir/Parameters/{parameters}"
  * resource = {parameters}
  * request
    * method = #GET
    * url = "https://{endpointPrefix}.example.org/fhir/Subscription/{subscriptionId}/$status"
  * response.status = "200"

RuleSet: SubParameters(subscription, resource, number)
* parameter[subscription].valueReference = Reference({subscription})
* parameter[topic].valueCanonical = "http://hl7.org/fhir/us/sdoh-clinicalcare/SubscriptionTopic/Task"
* parameter[status].valueCode = #active
* parameter[type].valueCode = #event-notification
* parameter[notificationEvent]
  * part[eventNumber].valueString = "{number}"
  * part[eventFocus].valueReference = Reference({resource})


// PA RuleSets
RuleSet: Note(time, author, authorName, note)
* note[+]
  * authorReference = Reference({author}) {authorName}
  * time = {time}
  * text = "{note}"

RuleSet: ConditionPA(patient, patientName, asserter, asserterName, onset)
* clinicalStatus = $clinicalStatus#active
* verificationStatus = $verifyStatus#confirmed
* category[+] = $condition-category#health-concern
* subject = Reference({patient}) {patientName}
* onsetDateTime = "{onset}"
* asserter = Reference({asserter}) {asserterName}

RuleSet: Condition(patient, patientName, asserter, asserterName, code, display, onset)
* insert ConditionPA({patient}, {patientName}, {asserter}, {asserterName}, {onset})
* code = {code} {display}


RuleSet: CarePlan(start, end, patient, patientName, author, authorName, detail)
* text
  * status = #additional
  * div = "<div xmlns=\"http://www.w3.org/1999/xhtml\">{detail}</div>"
* status = #active
* intent = #plan
* subject = Reference({patient}) {patientName}
* period
  * start = "{start}"
  * start = "{end}"
* author = Reference({author}) {authorName}

RuleSet: Goal(patient, patientName, status, description)
* lifecycleStatus = #active
* achievementStatus = $goal-achievement#{status}
* description.text = "{description}"
* subject = Reference({patient}) {patientName}

RuleSet: GoalTarget(due, loinc, display, quantity)
* target
  * measure = $loinc#{loinc} {display}
  * detailQuantity = {quantity}
  * dueDate = "{due}"

RuleSet: ExerciseReferral(start, end, patient, patientName, author, authorName, code, display)
* status = #active
* intent = #order
* priority = #routine
* code = {code} "{display}"
* subject = Reference({patient}) {patientName}
* requester = Reference({author}) {authorName}
* authoredOn = "{start}"
* occurrencePeriod
  * start = "{start}"
  * end = "{end}"

RuleSet: ExerciseRx(start, end, patient, patientName, author, authorName)
* insert ExerciseReferral({start}, {end}, {patient}, {patientName}, {author}, {authorName}, $sct#229065009, [[Exercise therapy (regime/therapy)]])
* performer = Reference({patient}) {patientName}

RuleSet: FulfillTask(patient, patientName, requester, requesterName, owner, ownerName, order, status, date)
* status = #{status}
* intent = #order
* code = $task-code#fulfill
* focus = Reference({order})
* requester = Reference({requester}) {requesterName}
* for = Reference({patient}) {patientName}
* authoredOn = "{date}"
* owner = Reference({owner}) {ownerName}

RuleSet: QuestionnaireTask(patient, patientName, requester, requesterName, priority, date, status, canonical, description)
* status = #{status}
* intent = #order
* priority = #{priority}
* code = $SDC-Temp#complete-questionnaire
* description = "{description}"
* for = Reference({patient}) {patientName}
* owner = Reference({patient}) {patientName}
* authoredOn = {date}
* requester = Reference({requester}) {requesterName}
* input[Questionnaire].valueCanonical = "{canonical}"

RuleSet: ReviewTask(patient, patientName, requester, requesterName, priority, date, status, content, description)
* status = #{status}
* intent = #order
* priority = #{priority}
* code = $SDOHCC-Temp#review-material
* focus = Reference({content})
* description = "{description}"
* for = Reference({patient}) {patientName}
* owner = Reference({patient}) {patientName}
* authoredOn = {date}
* requester = Reference({requester}) {requesterName}

RuleSet: DocRefVideo(url)
* status = #current
* content[+]
  * attachment
    * contentType = #video/mp4
    * url = "{url}"

RuleSet: Questionnaire(url, version)
* url = "{url}"
* version = "{version}"
* status = #active
* subjectType = #Patient

RuleSet: Question(linkId, type, text)
* item[+]
  * linkId = "{linkId}"
  * text = "{text}"
  * type = #{type}

RuleSet: QuestionnaireResponse(patient, patientName, date, questionnaire)
* status = #completed
* questionnaire = "{questionnaire}"
* subject = Reference({patient}) {patientName}
* authored = {date}

RuleSet: BooleanAnswer(linkId, answer, text)
* item[+]
  * linkId = "{linkId}"
  * text = "{text}"
  * answer.valueBoolean = {answer}

RuleSet: StringAnswer(linkId, answer, text)
* item[+]
  * linkId = "{linkId}"
  * text = "{text}"
  * answer.valueString = {answer}

RuleSet: DiagnosticReport(patient, patientName, performer, performerName, code, display, order, start, end, base64)
* basedOn = Reference({order})
* status = #final
* code = {code} {display}
* subject = Reference({patient}) {patientName}
* effectivePeriod
  * start = "{start}"
  * end   = "{end}"
* performer = Reference({performer}) {performerName}
* presentedForm
  * contentType = #application/pdf
  * data = {base64}


// Bundle RuleSets
RuleSet: SearchBundle(count, search)
* type = #searchset
* total = {count}
* link
  * relation = "self"
  * url = "{search}"

RuleSet: EntryMatch(type, resourceId)
* entry[+]
  * fullUrl = "http://example.org/fhir/{type}/{resourceId}"
  * resource = {resourceId}
  * search.mode = #match

RuleSet: EntryInclude(type, resourceId)
* entry[+]
  * fullUrl = "http://example.org/fhir/{type}/{resourceId}"
  * resource = {resourceId}
  * search.mode = #include


// Observation RuleSets
RuleSet: Observation(patient, patientName, performer, performerName, effective)
* status = #final
* subject = Reference({patient}) {patientName}
* effectiveDateTime = "{effective}"
* performer = Reference({performer}) {performerName}

RuleSet: ObservationPeriod(patient, patientName, performer, performerName, start, end)
* status = #final
* subject = Reference({patient}) {patientName}
* effectivePeriod
  * start = "{start}"
  * end = "{end}"
* performer = Reference({performer}) {performerName}

// Exercise Vital Sign
RuleSet: DaysPerWeek(patient, patientName, performer, performerName, effective, value)
* insert Observation({patient}, {patientName}, {performer}, {performerName}, {effective})
* code = $loinc#89555-7 "How many days per week did you engage in moderate to strenuous physical activity in the last 30 days"
* valueQuantity = {value} 'd/wk' "days per week"

RuleSet: MinPerDay(patient, patientName, performer, performerName, effective, value)
* insert Observation({patient}, {patientName}, {performer}, {performerName}, {effective})
* code = $loinc#68516-4 "On those days that you engage in moderate to strenuous exercise, how many minutes, on average, do you exercise"
* valueQuantity = {value} 'min/d' "minutes per day"

RuleSet: MinPerWeek(patient, patientName, performer, performerName, effective, value)
* insert Observation({patient}, {patientName}, {performer}, {performerName}, {effective})
* code = $loinc#82290-8 "Frequency of moderate to vigorous aerobic physical activity"
* valueQuantity = {value} 'min/wk' "minutes per week"

RuleSet: StrengthPerWeek(patient, patientName, performer, performerName, effective, value)
* insert Observation({patient}, {patientName}, {performer}, {performerName}, {effective})
* code = $loinc#82291-6 "Frequency of muscle-strengthening physical activity"
* valueQuantity = {value} 'd/wk' "days per week"

// Activity Measures
RuleSet: ActivityGroup(patient, patientName, performer, performerName, effective)
* insert Observation({patient}, {patientName}, {performer}, {performerName}, {effective})
* code = PATemporaryCodes#PAPanel "Physical Activity Panel"

RuleSet: HasMember(target)
* hasMember = Reference({target})

RuleSet: ActivityType(patient, patientName, performer, performerName, effective, code, display)
* insert Observation({patient}, {patientName}, {performer}, {performerName}, {effective})
* code = $loinc#73985-4 "Exercise activity"
* valueCodeableConcept = $loinc#{code} {display}

RuleSet: ActivityDuration(patient, patientName, performer, performerName, effective, value)
* insert Observation({patient}, {patientName}, {performer}, {performerName}, {effective})
* code = $loinc#55411-3 "Exercise duration"
* valueQuantity = {value} 'min' "minutes"

RuleSet: ActivityModerate(patient, patientName, performer, performerName, effective, value)
* insert Observation({patient}, {patientName}, {performer}, {performerName}, {effective})
* code = $loinc#77592-4 "Moderate physical activity [IPAQ]"
* valueQuantity = {value} 'min' "minutes"

RuleSet: ActivityVigorous(patient, patientName, performer, performerName, effective, value)
* insert Observation({patient}, {patientName}, {performer}, {performerName}, {effective})
* code = $loinc#77593-2 "Vigorous physical activity [IPAQ]"
* valueQuantity = {value} 'min' "minutes"

RuleSet: PeakHeartRate(patient, patientName, performer, performerName, effective, value)
* insert Observation({patient}, {patientName}, {performer}, {performerName}, {effective})
* code = $loinc#55426-1 "Heart rate unspecified time maximum by Pedometer"
* valueQuantity = {value} '/min' "beats per minute"

RuleSet: MeanHeartRate(patient, patientName, performer, performerName, effective, value)
* insert Observation({patient}, {patientName}, {performer}, {performerName}, {effective})
* code = $loinc#55425-3 "Heart rate unspecified time mean by Pedometer"
* valueQuantity = {value} '/min' "beats per minute"

RuleSet: ActivityCalories(patient, patientName, performer, performerName, effective, value)
* insert Observation({patient}, {patientName}, {performer}, {performerName}, {effective})
* code = $loinc#55424-6 "Calories burned in unspecified time Pedometer"
* valueQuantity = {value} 'kcal' "kilocalories"

RuleSet: ActivityExperience(patient, patientName, performer, performerName, effective, code, display)
* insert Observation({patient}, {patientName}, {performer}, {performerName}, {effective})
* code = PATemporaryCodes#Experience "Experience of Activity"
* valueCodeableConcept = PATemporaryCodes#{code} {display}


// Time-based Measures
RuleSet: DailySteps(patient, patientName, performer, performerName, effective, value)
* insert Observation({patient}, {patientName}, {performer}, {performerName}, {effective})
* code = $loinc#41950-7 "Number of steps in 24 hour Measured"
* valueQuantity = {value} '/d' "steps per day"

RuleSet: DailyPeakHR(patient, patientName, performer, performerName, effective, value)
* insert Observation({patient}, {patientName}, {performer}, {performerName}, {effective})
* code = $loinc#8873-2  "Heart rate 24 hour maximum"
* valueQuantity = {value} '/min' "beats per minute"

RuleSet: RestingHR(patient, patientName, performer, performerName, start, end, value)
* insert ObservationPeriod({patient}, {patientName}, {performer}, {performerName}, {start}, {end})
* code = $loinc#40443-4 "Heart rate --resting"
* valueQuantity = {value} '/min' "beats per minute"

RuleSet: DailyCalories(patient, patientName, performer, performerName, effective, value)
* insert Observation({patient}, {patientName}, {performer}, {performerName}, {effective})
* code = $loinc#41979-6 "Calories burned in 24 hour Calculated"
* valueQuantity = {value} 'kcal/d' "kilokalories per day"

// Bundle RuleSets
RuleSet: DocumentBundle(uuid, documentdate)
* type = #document
* identifier.system = "urn:oid:2.16.724.4.8.10.200.10"
* identifier.value = {uuid}
* timestamp = {documentdate}

RuleSet: EntryDocument(uuid, resourceId)
* entry[+]
  * fullUrl = {uuid}
  * resource = {resourceId}

RuleSet: EntryTransaction(type, uuid, resourceId)
* entry[+]
  * fullUrl = {uuid}
  * resource = {resourceId}
  * request.method = #POST
  * request.url = {type}

// Bundle RuleSets
RuleSet: MessageBundle(uuid, documentdate)
* type = #message
* identifier.system = "urn:ietf:rfc:3986"
* identifier.value = {uuid}
* timestamp = {documentdate}



Profile:        ReferenceRest
Parent:         Reference
Id:             reference-rest
Title:          "Reference - RESTful"
Description:    "A Reference data type where the referenced resource is expected to be resolvable RESTfully."
* reference 1..1 MS
* display MS

Profile:       ReferenceRestOrLogical
Parent:        Reference
Id:            reference-rest-or-logical
Title:         "Reference - RESTful or Logical"
Description:   "A Reference data type where the referenced resource could be resolvable RESTfully or pointed to logically."
* obeys PA-ident-1 and PA-ident-2
* reference MS
  * ^condition[+] = PA-ident-1
  * ^condition[+] = PA-ident-2
* identifier MS
  * ^condition[+] = PA-ident-1
  * system = "http://hl7.org/fhir/sid/us-npi"
  * value 1..1 MS
* display MS
  * ^condition[+] = PA-ident-2

Invariant:   PA-ident-1
Description: "reference or identifier must be present"
Expression:  "reference.exists() or identifier.exists()"
Severity:    #error
XPath:       "exists(f:reference) or exists(f:identifier)"

Invariant:   PA-ident-2
Description: "If reference is not present, display must be present"
Expression:  "reference.exists().not() implies display.exists()"
Severity:    #error
XPath:       "exists(f:reference) or exists(f:display)"
