using System;
using System.Data.SqlClient;
using System.Web.Configuration;

namespace HR
{
    public partial class LogIn : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                UserName.Text = "";
                Password.Text = "";
            }
        }

        protected void Login(object sender, EventArgs e)
        {
            errorLabel.Visible = false;
            errorLabel.Text = "";

            if (string.IsNullOrWhiteSpace(UserName.Text) || string.IsNullOrWhiteSpace(Password.Text))
            {
                errorLabel.Text = "Please enter both User Name and Password.";
                errorLabel.Visible = true;
                return;
            }

            int id;
            if (!Int32.TryParse(UserName.Text, out id))
            {
                errorLabel.Text = "User Name must be a number.";
                errorLabel.Visible = true;
                return;
            }

            string pass = Password.Text;
            string connStr = WebConfigurationManager.ConnectionStrings["GUCera"].ConnectionString;

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                using (SqlCommand cmd = new SqlCommand("SELECT dbo.EmployeeLoginValidation(@employee_ID, @password)", conn))
                {
                    cmd.Parameters.AddWithValue("@employee_ID", id);
                    cmd.Parameters.AddWithValue("@password", pass);

                    conn.Open();
                    object result = cmd.ExecuteScalar();
                    conn.Close();

                    bool isValid = (result != null && Convert.ToInt32(result) == 1);

                    if (isValid)
                    {
                        Session["EmployeeID"] = id;
                        Session["Role"] = "Employee";
                        Response.Redirect("EmployeeHome.aspx");
                    }
                    else
                    {
                        errorLabel.Text = "Invalid ID or password, Please try again.";
                        errorLabel.Visible = true;
                    }
                }
            }
            catch (SqlException ex)
            {
                errorLabel.Text = "Database connection error: " + ex.Message;
                errorLabel.Visible = true;
            }
            catch (Exception ex)
            {
                errorLabel.Text = "An error occurred: " + ex.Message;
                errorLabel.Visible = true;
            }

            Password.Text = "";
        }
    }
}
