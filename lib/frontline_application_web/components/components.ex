defmodule FrontlineApplicationWeb.Components do
  use Phoenix.Component

  attr :name, :string, required: true
  attr :current_time, :any, required: true
  attr :description, :string, required: true

  def timezone(assigns) do
    ~H"""
    <div class="flex justify-between items-center rounded-lg border border-gray-200 py-4 px-6">
      <div>
        <div class="text-lg font-semibold text-gray-700 m-0">{@name}</div>
        <div class="text-gray-500 m-0">{@description}</div>
      </div>

      <div class="text-sm text-gray-700">
        {Calendar.strftime(
          @current_time |> DateTime.shift_zone!(@name),
          "%a, %b %-d, %Y"
        )}
      </div>
      <div class="text-lg font-semibold text-gray-700">
        {Calendar.strftime(
          @current_time |> DateTime.shift_zone!(@name),
          "%-I:%M %p"
        )}
      </div>
    </div>
    """
  end

  attr :current_time, :any, required: true

  def timezones(assigns) do
    ~H"""
    <div class="space-y-4">
      <.timezone current_time={@current_time} name="America/Los_Angeles" description="PT (UTC-8)" />
      <.timezone current_time={@current_time} name="America/Denver" description="MT (UTC-7)" />
      <.timezone current_time={@current_time} name="America/Sao_Paulo" description="BRT (UTC-3)" />
    </div>
    """
  end
end
