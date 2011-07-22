class ExactTarget::Subscriber < ExactTarget::Base

  def create(attributes = {})
      attr = attributes.clone
      email = attr.delete(:email)
      skip_welcome = attr.delete(:skip_welcome)

      mail_attributes = {}
      mail_attributes["First Name"] = attr.delete(:first_name)
      mail_attributes["Last Name"] = attr.delete(:last_name)
      mail_attributes["Zipcode"] = attr.delete(:zip_code)
      mail_attributes.merge(attr)

      send_request create_body(email, mail_attributes)
      queue_triggered_send(:welcome, email) unless skip_welcome
      self
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
