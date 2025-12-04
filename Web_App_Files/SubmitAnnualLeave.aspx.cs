using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.Configuration;

namespace HR
{
    public partial class SubmitAnnualLeave : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            lblMessage.Text = "";
            lblError.Text = "";
        }

        protected void SubmitLeave_Click(object sender, EventArgs e)
        {
            lblMessage.Text = "";
            lblError.Text = "";

            // --- LOGIN CHECK ---
            if (Session["EmployeeID"] == null)
            {
                lblError.Text = "Please log in first.";
                return;
            }

            int employeeId = Convert.ToInt32(Session["EmployeeID"]);

            DateTime startDate, endDate;
            int replacementId;

            // --- VALIDATE START DATE ---
            if (!DateTime.TryParse(txtStartDate.Text, out startDate))
            {
                lblError.Text = "Invalid start date.";
                return;
            }

            // --- VALIDATE END DATE ---
            if (!DateTime.TryParse(txtEndDate.Text, out endDate))
            {
                lblError.Text = "Invalid end date.";
                return;
            }

            if (startDate > endDate)
            {
                lblError.Text = "Start date cannot be after end date.";
                return;
            }

            // --- REPLACEMENT EMPLOYEE IS NOW REQUIRED ---
            if (string.IsNullOrWhiteSpace(txtReplacement.Text))
            {
                lblError.Text = "Replacement employee ID is required.";
                return;
            }

            if (!Int32.TryParse(txtReplacement.Text.Trim(), out replacementId))
            {
                lblError.Text = "Replacement employee ID must be a valid number.";
                return;
            }

            string connStr = WebConfigurationManager
                                .ConnectionStrings["GUCera"].ConnectionString;

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                using (SqlCommand cmd = new SqlCommand("Submit_annual", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@employee_ID", employeeId);
                    cmd.Parameters.AddWithValue("@replacement_emp", replacementId);
                    cmd.Parameters.AddWithValue("@start_date", startDate);
                    cmd.Parameters.AddWithValue("@end_date", endDate);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                    conn.Close();

                    lblMessage.Text = "Annual leave submitted successfully.";
                }
            }
            catch (SqlException ex)
            {
                lblError.Text = "Database error: " + ex.Message;
            }
            catch (Exception ex)
            {
                lblError.Text = "Unexpected error: " + ex.Message;
            }
        }
    }
}
