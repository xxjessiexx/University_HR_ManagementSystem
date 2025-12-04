using System;
using System.Data.SqlClient;
using System.Web.Configuration;
using System.Web.UI;

namespace HR
{
    public partial class LeaveStatus : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["EmployeeID"] == null)
            {
                Response.Redirect("LogIn.aspx");
            }

            // Remove automatic ViewLeaveStatus(); call
        }



        protected void ViewLeaveStatus_Click(object sender, EventArgs e)
        {
            ViewLeaveStatus();
        }

        private void ViewLeaveStatus()
        {
            if (Session["EmployeeID"] == null)
            {
                lblLeaveStatusError.Text = "Please log in first.";
                return;
            }

            int employeeId = Convert.ToInt32(Session["EmployeeID"]);
            string connStr = WebConfigurationManager.ConnectionStrings["GUCera"].ConnectionString;

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = "SELECT * FROM status_leaves(@employee_ID)";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@employee_ID", employeeId);
                        conn.Open();

                        SqlDataReader reader = cmd.ExecuteReader();
                        gvLeaveStatus.DataSource = reader;
                        gvLeaveStatus.DataBind();

                        conn.Close();
                        lblLeaveStatusError.Text = "";
                    }
                }
            }
            catch (SqlException ex)
            {
                lblLeaveStatusError.Text = "Database error: " + ex.Message;
            }
            catch (Exception ex)
            {
                lblLeaveStatusError.Text = "Unexpected error: " + ex.Message;
            }
        }
    }
}
