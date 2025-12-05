using System;

namespace UNI
{
    public partial class AdminLogin : System.Web.UI.Page
    {
        // === CHANGE THESE BEFORE SUBMISSION IF YOU WANT DIFFERENT CREDENTIALS ===
        private const string ADMIN_ID = "admin";        // example: "admin"
        private const string ADMIN_PASSWORD = "admin123"; // example: "admin123"
        // ======================================================================

        protected void Page_Load(object sender, EventArgs e)
        {
            // if already logged in, redirect to admin home
            if (Session["IsAdmin"] != null && (bool)Session["IsAdmin"] == true)
            {
                Response.Redirect("~/AdminHome.aspx");

            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            lblMsg.ForeColor = System.Drawing.Color.Red;
            lblMsg.Text = "";

            string id = txtAdminID.Text.Trim();
            string pass = txtAdminPass.Text;

            if (string.IsNullOrEmpty(id) || string.IsNullOrEmpty(pass))
            {
                lblMsg.Text = "Please enter both Admin ID and Password.";
                return;
            }

            // Simple case-insensitive compare for ID, case-sensitive for password (adjust if you want both case-insensitive)
            if (string.Equals(id, ADMIN_ID, StringComparison.OrdinalIgnoreCase) &&
                pass == ADMIN_PASSWORD)
            {
                // Successful login
                Session["IsAdmin"] = true;
                Session["AdminID"] = ADMIN_ID;
                // Optionally set a short session timeout for security
                Session.Timeout = 30; // minutes

                // Redirect to Admin Home
                // Redirect to Admin Home
                Response.Redirect("~/AdminHome.aspx");

            }
            else
            {
                lblMsg.Text = "Invalid admin credentials.";
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            // Clear fields
            txtAdminID.Text = "";
            txtAdminPass.Text = "";
            lblMsg.Text = "";
        }
    }
}
