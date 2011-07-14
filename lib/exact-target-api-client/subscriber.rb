class ExactTarget::Subscriber < ExactTarget::Base

  def create(attr)
      email = attr.delete(:email)
      send_request create_body(email, attr)
      queue_triggered_send(ExactTarget::Base.welcome_send_definition, email)
  end

  def create_body(email, attr)
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
          "EmailAddress" => email,
          "Lists" => {
            "ID" => ExactTarget::Base.master_list_id,
          },
          "Attributes" => build_attributes(attr)
          },
          :attributes! => {
            "Objects" => {"xsi:type" => "Subscriber"}
        }
    }
  end

end

#
#            [
#              build_attribute("First Name", user.profile.first_name),
#              build_attribute("Last Name", user.profile.last_name),
#              build_attribute("Zipcode", user.profile.zip_code)
#            ]
