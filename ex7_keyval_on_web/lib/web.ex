defmodule KeyVal.Web do
  use Plug.Router
  plug :match
  plug Plug.Parsers, parsers: [:json],
  pass:  ["application/json"],
  json_decoder: Jason
  plug :dispatch

  post "/get" do
    case conn.body_params do
      %{"name" => store_name, "key" => key} ->  {_,val} = KeyVal.Server.get(store_name,key)
      send_resp(conn, 200, val)
      _ ->    send_resp(conn, 200, "Oops!")
    end
  end

  post "/put" do
    case conn.body_params do
      %{"name" => store_name, "key" => key ,"value" => value} -> KeyVal.Server.put(store_name,key,value)
      send_resp(conn, 200, "Success!")
      _ ->    send_resp(conn, 200, "Oops!")
    end
  end

  post "/create" do
    case conn.body_params do
      %{"name" => store_name} ->  KeyVal.Manager.create_store(store_name)
      send_resp(conn, 200, "Success!")
      _ ->    send_resp(conn, 200, "Oops!")
    end
  end

  post "/del" do
    case conn.body_params do
      %{"name" => store_name, "key" => key } ->  KeyVal.Server.del(store_name,key)
      send_resp(conn, 200, "Success!")
      _ ->    send_resp(conn, 200, "Oops!")
    end
  end

  match _ do
    send_resp(conn, 404, "Oops!")
  end

  def child_spec(_arg) do
    Plug.Cowboy.child_spec(
      scheme: :http,
      options: [port: 3000],
      plug: __MODULE__
) end
end
