using System;
using System.Data.SqlClient;

namespace UNI
{
    public partial class RemoveApprovedLeavesAttendance : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Page loads cleanly — no logic needed here for now.
        }

        protected void btnRemoveApproved_Click(object sender, EventArgs e)
        {
            // ---------------------------
            // Validate Employee ID input
            // ---------------------------
            if (string.IsNullOrWhiteSpace(txtEmpID.Text))
            {
                lblMessage.CssClass = "error";
                lblMessage.Text = "Please enter a valid Employee ID.";
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

            // ---------------------------
            // DB Connection String
            // ---------------------------
            string connStr =
                "Server=(localdb)\\MSSQLLocalDB;" +
                "Database=University_HR_ManagementSystem;" +
                "Trusted_Connection=True;";

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    // --------------------------------------------------------------
                    // DELETE attendance records that fall inside APPROVED leave dates
                    // --------------------------------------------------------------
                    string query = @"
                        DELETE FROM Attendance
                        WHERE emp_ID = @empID
                          AND [date] BETWEEN 
                            (
                                SELECT MIN(start_date)
                                FROM Leave l
                                JOIN Annual_Leave al ON al.request_ID = l.request_ID
                                WHERE al.emp_ID = @empID
                                  AND l.final_approval_status = 'Approved'
                            )
                          AND
                            (
                                SELECT MAX(end_date)
                                FROM Leave l
                                JOIN Annual_Leave al ON al.request_ID = l.request_ID
                                WHERE al.emp_ID = @empID
                                  AND l.final_approval_status = 'Approved'
                            );
                    ";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@empID", empID);

                    int rowsAffected = cmd.ExecuteNonQuery();

                    // ---------------------------
                    // SUCCESS MESSAGE
                    // ---------------------------
                    lblMessage.CssClass = "success";
                    lblMessage.Visible = true;
                    lblMessage.Text = $"{rowsAffected} attendance records removed due to approved leave.";
                }
            }
            catch (Exception ex)
            {
                // ---------------------------
                // ERROR MESSAGE
                // ---------------------------
                lblMessage.CssClass = "error";
                lblMessage.Visible = true;
                lblMessage.Text = "Error: " + ex.Message;
            }
        }
    }
}