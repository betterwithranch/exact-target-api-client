class ExactTarget::Subscriber < ExactTarget::Base

  def create(user)
      send_request create_body(user)
      queue_triggered_send(:welcome, user.email)
  end

  def create_body(user)
  {
        "Options" => {
          "SaveOptions" => {
            "SaveOption" => {
              "SaveAction" => "UpdateAdd",
              "PropertyName" => "*"
            }
          }
        },
        "Objects" => {
          "EmailAddress" => user.email,
          "Lists" => {
            "ID" => Email::ExactTarget::Base.master_list_id,
          },
          "Attributes" => [
              build_attribute("First Name", user.profile.first_name),
              build_attribute("Last Name", user.profile.last_name),
              build_attribute("Zipcode", user.profile.zip_code)
            ]
          },
          :attributes! => {
            "Objects" => {"xsi:type" => "Subscriber"}
        }
    }
  end
end
