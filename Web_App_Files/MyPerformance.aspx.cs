using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.Configuration;

namespace HR
{
    public partial class MyPerformance : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["EmployeeID"] == null)
            {
                Response.Redirect("LogIn.aspx");
                return;
            }

            if (!IsPostBack)
            {
                semesterTextBox.Text = "";
                errorLabel.Visible = false;
            }
        }

        protected void GetPerformance_Click(object sender, EventArgs e)
        {
            errorLabel.Visible = false;
            gvPerformance.DataSource = null;
            gvPerformance.DataBind();

            string semester = semesterTextBox.Text.Trim();
            if (string.IsNullOrEmpty(semester))
            {
                errorLabel.Text = "Please enter a semester.";
                errorLabel.Visible = true;
                return;
            }

            if (!int.TryParse(Session["EmployeeID"].ToString(), out int employeeId))
            {
                errorLabel.Text = "Employee not logged in properly.";
                errorLabel.Visible = true;
                return;
            }

            string connStr = WebConfigurationManager.ConnectionStrings["GUCera"].ConnectionString;

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                using (SqlCommand cmd = new SqlCommand("SELECT * FROM dbo.MyPerformance(@employee_ID, @period)", conn))
                {
                    cmd.Parameters.AddWithValue("@employee_ID", employeeId);
                    cmd.Parameters.AddWithValue("@period", semester);

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    if (dt.Rows.Count > 0)
                    {
                        gvPerformance.DataSource = dt;
                        gvPerformance.DataBind();
                    }
                    else
                    {
                        errorLabel.Text = "No performance records found for that semester.";
                        errorLabel.Visible = true;
                    }
                }
            }
            catch (Exception ex)
            {
                errorLabel.Text = "Unexpected error: " + ex.Message;
                errorLabel.Visible = true;
            }
        }
    }
}
