using System;
using System.Data.SqlClient;

namespace UNI
{
    public partial class RemoveHolidayAttendance : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Do not write anything here!
            // Page_Load overwriting the label was the reason your button did nothing.
        }

        protected void btnRemove_Click(object sender, EventArgs e)
        {
            lblMessage.Visible = false;

            string connStr =
                "Server=(localdb)\\MSSQLLocalDB;" +
                "Database=University_HR_ManagementSystem;" +
                "Trusted_Connection=True;";

            string query = @"
                DELETE A
                FROM Attendance A
                JOIN Holiday H
                    ON A.date BETWEEN H.from_date AND H.to_date;
            ";

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    SqlCommand cmd = new SqlCommand(query, conn);
                    int rows = cmd.ExecuteNonQuery();

                    lblMessage.Visible = true;
                    lblMessage.CssClass = "success";
                    lblMessage.Text = rows + " attendance records were removed.";
                }
            }
            catch (Exception ex)
            {
                lblMessage.Visible = true;
                lblMessage.CssClass = "error";
                lblMessage.Text = "Error: " + ex.Message;
            }
        }
    }
}