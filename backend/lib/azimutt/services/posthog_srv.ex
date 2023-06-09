defmodule Azimutt.Services.PostHogSrv do
  @moduledoc false
  require Logger
  alias Azimutt.Tracking.Event
  alias Azimutt.Utils.Result
  alias Azimutt.Utils.Stringx

  # see https://posthog.com/docs/libraries/elixir
  def send_event(%Event{} = event) do
    Posthog.capture(
      event.name,
      Map.merge(event.details || %{}, %{
        distinct_id: event.created_by.id,
        "$lib": event.details["$lib"] || "back",
        instance: Azimutt.config(:host),
        organization_id: event.organization_id,
        project_id: event.project_id,
        # see https://posthog.com/docs/getting-started/user-properties
        "$set": %{
          user_id: event.created_by.id,
          name: event.created_by.name,
          email: event.created_by.email,
          onboarding: event.created_by.onboarding,
          profile: "https://#{Azimutt.config(:host)}/admin/users/#{event.created_by.id}"
        }
      }),
      event.created_at
    )
    |> Result.tap_error(fn err -> Logger.error("PostHogSrv.send_event: #{Stringx.inspect(err)}") end)
  end
end