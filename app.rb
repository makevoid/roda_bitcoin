require_relative 'config/env'

class App < Roda

  plugin(:assets,
    css: ["style.css"],
    js:  ["vendor/underscore.js", "vendor/qrcode.js"],
  )

  plugin :render, engine: "haml"
  plugin :partials
  plugin :not_found

  # TODO: move in helpers

  def json_route
    response['Content-Type'] = 'application/json'
  end

  def wallet
    @@wallet ||= Wallet.new
  end

  def params
    symbolize request.params
  end

  # monkeypatches

  def symbolize(hash)
    Hash[hash.map{|(k,v)| [k.to_sym,v]}]
  end

  # view

  def body_class
    request.path.split("/")[1]
  end

  def table_row(text, colspan: 5)
    haml_tag(:tr) do
      haml_tag(:td, colspan: colspan) do
        haml_concat text
      end
    end
  end

  route do |r|

    r.root do
      r.redirect "/blocks"
    end

    r.on "blocks" do
      r.is do
        r.get do
          view "blocks"
        end
      end

      r.on ":id" do |id|
        r.is do
          r.get do
            view "block"
          end
        end
      end
    end

    r.assets
  end

  not_found do
    view "not_found"
  end
end
