module Models.Organization exposing (Organization, canAnalyse, canChangeColor, canCreateLayout, canExportSchema, canSaveProject, canShareProject, canShowTables, decode, encode, isLastLayout, one, zero)

import Json.Decode as Decode
import Json.Encode as Encode exposing (Value)
import Libs.Json.Decode as Decode
import Libs.Json.Encode as Encode
import Libs.Maybe as Maybe
import Models.CleverCloudResource as CleverCloudResource exposing (CleverCloudResource)
import Models.Feature as Feature
import Models.HerokuResource as HerokuResource exposing (HerokuResource)
import Models.OrganizationId as OrganizationId exposing (OrganizationId)
import Models.OrganizationName as OrganizationName exposing (OrganizationName)
import Models.OrganizationSlug as OrganizationSlug exposing (OrganizationSlug)
import Models.Plan as Plan exposing (Plan)


type alias Organization =
    { id : OrganizationId
    , slug : OrganizationSlug
    , name : OrganizationName
    , plan : Plan
    , logo : String
    , description : Maybe String
    , cleverCloud : Maybe CleverCloudResource
    , heroku : Maybe HerokuResource
    }


canShowTables : Int -> Int -> { x | organization : Maybe Organization } -> Bool
canShowTables newTables layoutTables projectRef =
    projectRef.organization |> Maybe.mapOrElse (.plan >> .layoutTables >> Maybe.all (\max -> layoutTables + newTables <= max)) (newTables + layoutTables <= Feature.layoutTables.default)


canChangeColor : { x | organization : Maybe Organization } -> Bool
canChangeColor projectRef =
    projectRef.organization |> Maybe.mapOrElse (.plan >> .colors) Feature.colors.default


isLastLayout : Int -> { x | organization : Maybe Organization } -> Bool
isLastLayout layouts projectRef =
    projectRef.organization |> Maybe.mapOrElse (.plan >> .projectLayouts >> Maybe.any (\l -> layouts >= l)) (layouts + 1 == Feature.projectLayouts.default)


canCreateLayout : Int -> { x | organization : Maybe Organization } -> Bool
canCreateLayout layouts projectRef =
    projectRef.organization |> Maybe.mapOrElse (.plan >> .projectLayouts >> Maybe.all (\max -> max + 1 > layouts)) (layouts < Feature.projectLayouts.default)


canExportSchema : { x | organization : Maybe Organization } -> Bool
canExportSchema projectRef =
    projectRef.organization |> Maybe.mapOrElse (.plan >> .schemaExport) Feature.schemaExport.default


canShareProject : { x | organization : Maybe Organization } -> Bool
canShareProject projectRef =
    projectRef.organization |> Maybe.mapOrElse (.plan >> .projectShare) Feature.projectShare.default


canAnalyse : { x | organization : Maybe Organization } -> Bool
canAnalyse projectRef =
    projectRef.organization |> Maybe.mapOrElse (\o -> o.plan.analysis /= Feature.analysis.preview) Feature.analysis.default


canSaveProject : Int -> Organization -> Bool
canSaveProject orgProjects organization =
    organization.plan.projects |> Maybe.mapOrElse (\p -> orgProjects < p) True


encode : Organization -> Value
encode value =
    Encode.notNullObject
        [ ( "id", value.id |> OrganizationId.encode )
        , ( "slug", value.slug |> OrganizationSlug.encode )
        , ( "name", value.name |> OrganizationName.encode )
        , ( "plan", value.plan |> Plan.encode )
        , ( "logo", value.logo |> Encode.string )
        , ( "description", value.description |> Encode.maybe Encode.string )
        , ( "clever_cloud", value.cleverCloud |> Encode.maybe CleverCloudResource.encode )
        , ( "heroku", value.heroku |> Encode.maybe HerokuResource.encode )
        ]


decode : Decode.Decoder Organization
decode =
    Decode.map8 Organization
        (Decode.field "id" OrganizationId.decode)
        (Decode.field "slug" OrganizationSlug.decode)
        (Decode.field "name" OrganizationName.decode)
        (Decode.field "plan" Plan.decode)
        (Decode.field "logo" Decode.string)
        (Decode.maybeField "description" Decode.string)
        (Decode.maybeField "clever_cloud" CleverCloudResource.decode)
        (Decode.maybeField "heroku" HerokuResource.decode)


zero : Organization
zero =
    { id = OrganizationId.zero
    , slug = OrganizationId.zero
    , name = "zero"
    , plan = Plan.docSample
    , logo = "https://azimutt.app/images/logo_dark.svg"
    , description = Nothing
    , cleverCloud = Nothing
    , heroku = Nothing
    }


one : Organization
one =
    { id = OrganizationId.one
    , slug = OrganizationId.one
    , name = "one"
    , plan = Plan.docSample
    , logo = "https://azimutt.app/images/logo_dark.svg"
    , description = Nothing
    , cleverCloud = Nothing
    , heroku = Nothing
    }
