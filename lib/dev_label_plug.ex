defmodule DevLabelPlug do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    conn
    |> Plug.Conn.register_before_send(fn conn_x ->
      %{conn_x | resp_body: insert_label(conn_x.resp_body)}
    end)
  end

  defp insert_label(body) when is_binary(body) do
    css_path = Application.get_env(:dev_label_plug, :css_path)
    css_name = "dev-label.css"

    {:ok, css} = File.read("#{css_path}/#{css_name}")

    tag = "<style>#{css}</style>" <>
          "<div class='dev-label-wrapper fixed left'>" <>
            "<div class='dev-label red'>" <>
              "<span class='dev-label-text'>#{Mix.env}</span>" <>
            "</div>" <>
          "</div>"

    Regex.replace(~r/(<body[^>]*>)/i, body, "\\1#{tag}")
  end

  defp insert_label(body) when is_list(body) do
    [head | tail] = body
    [insert_label(head) | insert_label(tail)]
  end

  defp insert_label(body) do
    body
  end
end
