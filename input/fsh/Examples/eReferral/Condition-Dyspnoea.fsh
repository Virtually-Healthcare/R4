Instance: Condition-Dyspnoea
InstanceOf: Condition
Title: "Condition - Dyspnoea"
Description: """
Condition Dyspnoea

Loosely based on [NHS Digital End of Life Care FHIR STU3 - Advance Treatment Preferences Atomic Unit](https://nhsconnect.github.io/FHIR-END-OF-LIFE-API/api_eol_atp.html)
"""
Usage: #example

* identifier.system = "urn:ietf:rfc:3986"
* identifier.value = "urn:uuid:71fae5af-0b9e-4b9e-b6af-3d1bb4e223a0"
* identifier.assigner.identifier.system = $ods-code
* identifier.assigner.identifier.value = "F83004"

* clinicalStatus = $condition-clinical#active
* verificationStatus = $condition-ver-status#confirmed
* severity = $sct#24484000 "Severe"

* subject.identifier.system = $nhs-number
* subject.identifier.value = "9449305552"
* subject.display = "Octavia CHISLETT"

* code = $sct#267036007 "Dyspnoea"

* onsetDateTime = "2018-08-20"

* asserter.identifier.system = $gmp-number
* asserter.identifier.value = "G3298457"
* asserter.display = "Dr Milan Koya"
