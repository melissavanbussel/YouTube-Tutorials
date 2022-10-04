# Load blastula package
library(blastula)

# Create file containing credentials for email account
# create_smtp_creds_file(file = "ggnot_throwaway_creds",
#                        user = "ggnot_throwaway@outlook.com",
#                        provider = "outlook")

# Generate the email object using blastula
my_email_object <- render_email("blastula_email.qmd")

# Send email
smtp_send(my_email_object,
          from = "ggnot_throwaway@outlook.com",
          to = "ggnot_throwaway@outlook.com",
          subject = paste0("Email from blastula on ", Sys.Date()),
          credentials = creds_file("ggnot_throwaway_creds"))