using System;
using System.Data;
using System.Data.SqlClient;

namespace UNI
{
    public partial class PerformanceWinter : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Do NOT load on page load
        }

        protected void btnLoadPerformance_Click(object sender, EventArgs e)
        {
            LoadWinterPerformance();
        }

        private void LoadWinterPerformance()
        {
            string connStr = "Server=(localdb)\\MSSQLLocalDB;Database=University_HR_ManagementSystem;Trusted_Connection=True;";
            lblMessage.Visible = false;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT p.performance_ID, p.rating, p.comments, p.semester, p.emp_ID,
                           e.first_name, e.last_name, e.dept_name
                    FROM Performance p
                    LEFT JOIN Employee e ON p.emp_ID = e.employee_ID
                    WHERE p.semester LIKE 'W%';
                ";

                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                GridViewPerformance.DataSource = dt;
                GridViewPerformance.DataBind();

                if (dt.Rows.Count == 0)
                {
                    lblMessage.Visible = true;
                    lblMessage.CssClass = "error";
                    lblMessage.Text = "No Winter semester performance found.";
                }
            }
        }
    }
}