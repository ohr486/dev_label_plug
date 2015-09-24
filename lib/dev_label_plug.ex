defmodule DevLabelPlug do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    case Mix.env do
      :prod -> conn
      _ -> conn
           |> Plug.Conn.register_before_send(fn conn_x ->
             if take_content_type(conn_x.resp_headers) |> is_text_html? &&
                conn_x.status |> is_not_redirect? do
               %{conn_x | resp_body: insert_label(conn_x.resp_body)}
             else
               conn_x
             end
           end)
    end
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

  defp take_content_type(headers) do
    headers |> Enum.find(&(&1 |> elem(0) == "content-type"))
  end

  defp is_text_html?(nil), do: false
  defp is_text_html?(header) do
    Regex.match?(~r/text\/html/i, elem(header, 1))
  end

  defp is_not_redirect?(status_code) when is_integer(status_code) do
    status_code < 300 || 400 <= status_code
  end
  defp is_not_redirect?(_), do: false

end
