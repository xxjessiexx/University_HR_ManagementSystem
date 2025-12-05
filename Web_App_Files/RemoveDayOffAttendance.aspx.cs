using System;
using System.Data.SqlClient;

namespace UNI
{
    public partial class RemoveDayOffAttendance : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // no auto-load
        }

        protected void btnRemoveDayOff_Click(object sender, EventArgs e)
        {
            lblMessage.Visible = false;

            // Validate input
            if (string.IsNullOrWhiteSpace(txtEmpID.Text))
            {
                lblMessage.CssClass = "error";
                lblMessage.Text = "Please enter an Employee ID.";
                lblMessage.Visible = true;
                return;
            }

            if (!int.TryParse(txtEmpID.Text, out int empID))
            {
                lblMessage.CssClass = "error";
                lblMessage.Text = "Employee ID must be a number.";
                lblMessage.Visible = true;
                return;
            }

            string connStr =
                "Server=(localdb)\\MSSQLLocalDB;" +
                "Database=University_HR_ManagementSystem;" +
                "Trusted_Connection=True;";

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    string query = @"
                        DELETE FROM Attendance
                        WHERE emp_ID = @empID
                          AND status = 'Absent' 
                          AND DATENAME(weekday, [date]) =
                                (SELECT official_day_off 
                                 FROM Employee 
                                 WHERE employee_ID = @empID);
                    ";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@empID", empID);

                    int removed = cmd.ExecuteNonQuery();

                    lblMessage.CssClass = "success";
                    lblMessage.Visible = true;
                    lblMessage.Text = removed + " day-off attendance records removed.";
                }
            }
            catch (Exception ex)
            {
                lblMessage.CssClass = "error";
                lblMessage.Visible = true;
                lblMessage.Text = "Error: " + ex.Message;
            }
        }
    }
}