/**********************************************************************
* Description: Script to migrate Ability Level data from OTA column to
*              the skel bone structure.
* Created By:  Nick Airdo @ Central Christian Church of the East Valley
* Date Created:	2/16/2009 10:16 AM
*
* $Workfile: 20090216_ConvertOTA_AbilityLevel_to_Skel_Bone.sql $
* $Revision: 2 $ 
* $Header: /trunk/Database/Scripts/cust/Cccev/ckin/20090216_ConvertOTA_AbilityLevel_to_Skel_Bone.sql   2   2009-02-18 09:54:44-07:00   nicka $
* 
* $Log: /trunk/Database/Scripts/cust/Cccev/ckin/20090216_ConvertOTA_AbilityLevel_to_Skel_Bone.sql $
*  
*  Revision: 2   Date: 2009-02-18 16:54:44Z   User: nicka 
*  corrected logic bug on last line 
**********************************************************************/

-- This is used with the Arena.Core.Bone utility classes:
DECLARE @OccurrenceTypeAttributeEntityTypeGUID uniqueidentifier
SET @OccurrenceTypeAttributeEntityTypeGUID = 'b8903b32-3200-41e3-8c08-66c372a38d12'

-- This is a system lookup
DECLARE @EntityLookupTypeID int
SELECT @EntityLookupTypeID = lookup_type_id FROM core_lookup_type WHERE guid = '15fe6acd-f986-4a92-9410-75eb67e531a6'

--------------------------------------------------------------------------
-- Add the Occurrence Type Attribute to the list of Entity lookup
--------------------------------------------------------------------------

IF NOT EXISTS (SELECT * FROM core_lookup WHERE guid = @OccurrenceTypeAttributeEntityTypeGUID)
BEGIN
INSERT INTO core_lookup ([guid],[lookup_type_id],[lookup_value],[lookup_qualifier],[lookup_qualifier2],[lookup_qualifier3],[lookup_qualifier4],[lookup_qualifier5],[lookup_qualifier6],[lookup_qualifier7],[lookup_qualifier8],[lookup_order],[active],[system_flag],[foreign_key])
     VALUES (@OccurrenceTypeAttributeEntityTypeGUID, @EntityLookupTypeID, 'Occurrence Type Attribute', '', '', '', '', '', '', '', '', 1, 1, 0, NULL)
END

-- This is a system lookup
DECLARE @OccurrenceTypeAttributeEntityID int
SELECT @OccurrenceTypeAttributeEntityID = lookup_id FROM core_lookup WHERE guid = @OccurrenceTypeAttributeEntityTypeGUID


-- Examine the existing content and skel_bone content
SELECT * FROM cust_cccev_ckin_occurrence_type_attribute WHERE ability_level_luid <> -1
SELECT * FROM skel_bone where entity_type = @OccurrenceTypeAttributeEntityID

--------------------------------------------------------------------------
-- Add the old Occurrence Type Attribute "ability level" as an entity in
-- the skel_bone table.
--------------------------------------------------------------------------

SELECT 'Add to skel_bone'
INSERT INTO	skel_bone
        (
			[topic_luid]
           ,[entity_type]
           ,[entity_id]
		)
SELECT 	ota.ability_level_luid as '[topic_luid]'
		, @OccurrenceTypeAttributeEntityID as '[entity_type]'
		, ota.occurrence_type_attribute_id  as '[entity_id]'
FROM	cust_cccev_ckin_occurrence_type_attribute ota
-- and it does not exist
WHERE
ota.ability_level_luid <> -1
AND
NOT EXISTS
	( SELECT b.entity_id FROM skel_bone b WHERE b.entity_id = ota.occurrence_type_attribute_id AND ota.entity_type = @OccurrenceTypeAttributeEntityID )

