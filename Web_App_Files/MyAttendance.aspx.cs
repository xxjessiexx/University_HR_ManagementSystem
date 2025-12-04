using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.Configuration;

namespace HR
{
    public partial class MyAttendance : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                gvAttendance.DataSource = null;
                gvAttendance.DataBind();
            }
        }

        protected void GetAttendance_Click(object sender, EventArgs e)
        {
            errorLabel.Visible = false;
            gvAttendance.DataSource = null;
            gvAttendance.DataBind();

            if (Session["EmployeeID"] == null)
            {
                errorLabel.Text = "Employee not logged in. Please login first.";
                errorLabel.Visible = true;
                return;
            }

            int employeeId = Convert.ToInt32(Session["EmployeeID"]);
            string connStr = WebConfigurationManager.ConnectionStrings["GUCera"].ConnectionString;

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = "SELECT * FROM dbo.MyAttendance(@employee_ID)";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@employee_ID", employeeId);

                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        if (dt.Rows.Count > 0)
                        {
                            gvAttendance.DataSource = dt;
                            gvAttendance.DataBind();
                        }
                        else
                        {
                            errorLabel.Text = "No attendance records found for the current month.";
                            errorLabel.Visible = true;
                        }
                    }
                }
            }
            catch (SqlException ex)
            {
                errorLabel.Text = "Database error: " + ex.Message;
                errorLabel.Visible = true;
            }
            catch (Exception ex)
            {
                errorLabel.Text = "Unexpected error: " + ex.Message;
                errorLabel.Visible = true;
            }
        }
    }
}
