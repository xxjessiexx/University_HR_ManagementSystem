using System;
using System.Data;
using System.Data.SqlClient;

namespace UNI
{
    public partial class AttendanceYesterday : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Do NOT load anything automatically
        }

        protected void btnLoadAttendance_Click(object sender, EventArgs e)
        {
            LoadYesterdayAttendance();
        }

        private void LoadYesterdayAttendance()
        {
            string connStr = "Server=(localdb)\\MSSQLLocalDB;Database=University_HR_ManagementSystem;Trusted_Connection=True;";
            lblMsg.Visible = false;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT *
                    FROM Attendance
                    WHERE [date] = CAST(DATEADD(day, -1, GETDATE()) AS date);
                ";

                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                GridViewAttendance.DataSource = dt;
                GridViewAttendance.DataBind();

                if (dt.Rows.Count == 0)
                {
                    lblMsg.Visible = true;
                    lblMsg.CssClass = "error";
                    lblMsg.Text = "No attendance found for yesterday.";
                }
            }
        }
    }
}