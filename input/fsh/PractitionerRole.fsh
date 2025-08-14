Profile:        PractitionerRole
Parent:         https://fhir.hl7.org.uk/StructureDefinition/UKCore-PractitionerRole
Id:             PractitionerRole
Title:          "PractitionerRole"
Description:    """
DRAFT Extension of UKCore PractitionerRole

"""

* practitioner 1..1 MS
* practitioner.identifier 1..1
* practitioner.identifier only PractitionerIdentifier
* practitioner.identifier.value MS
* practitioner.display MS

* organization 1..1 MS
* organization.identifier 1..1
* organization.identifier only OrganisationCode
* organization.identifier.value MS
* organization.display MS

* specialty from Specialty
* specialty.coding.code MS

* telecom.value MS

