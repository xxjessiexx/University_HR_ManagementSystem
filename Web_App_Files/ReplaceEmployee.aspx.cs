using System;
using System.Data.SqlClient;

namespace UNI
{
    public partial class ReplaceEmployee : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Page loads cleanly
        }

        protected void btnReplace_Click(object sender, EventArgs e)
        {
            lblMessage.Visible = false;

            // -----------------------
            // 1. VALIDATE INPUT
            // -----------------------
            if (string.IsNullOrWhiteSpace(txtEmp1.Text) ||
                string.IsNullOrWhiteSpace(txtEmp2.Text) ||
                string.IsNullOrWhiteSpace(txtFrom.Text) ||
                string.IsNullOrWhiteSpace(txtTo.Text))
            {
                ShowError("All fields are required.");
                return;
            }

            if (!int.TryParse(txtEmp1.Text, out int emp1))
            {
                ShowError("Emp1_ID must be a number.");
                return;
            }

            if (!int.TryParse(txtEmp2.Text, out int emp2))
            {
                ShowError("Emp2_ID must be a number.");
                return;
            }

            if (!DateTime.TryParse(txtFrom.Text, out DateTime from))
            {
                ShowError("Invalid From Date format.");
                return;
            }

            if (!DateTime.TryParse(txtTo.Text, out DateTime to))
            {
                ShowError("Invalid To Date format.");
                return;
            }

            // -----------------------
            // 2. DATABASE OPERATION
            // -----------------------
            string connStr =
                "Server=(localdb)\\MSSQLLocalDB;" +
                "Database=University_HR_ManagementSystem;" +
                "Trusted_Connection=True;";

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = @"
                        INSERT INTO Employee_Replace_Employee (Emp1_ID, Emp2_ID, from_date, to_date)
                        VALUES (@emp1, @emp2, @from, @to);
                    ";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@emp1", emp1);
                    cmd.Parameters.AddWithValue("@emp2", emp2);
                    cmd.Parameters.AddWithValue("@from", from);
                    cmd.Parameters.AddWithValue("@to", to);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                ShowSuccess("Employee replacement recorded successfully!");
            }
            catch (Exception ex)
            {
                ShowError("Database Error: " + ex.Message);
            }
        }

        // ----------------------------------------
        // 🩷 Helper Methods (Match Sakura Theme)
        // ----------------------------------------
        private void ShowError(string msg)
        {
            lblMessage.CssClass = "error";
            lblMessage.Text = msg;
            lblMessage.Visible = true;
        }

        private void ShowSuccess(string msg)
        {
            lblMessage.CssClass = "success";
            lblMessage.Text = msg;
            lblMessage.Visible = true;
        }
    }
}
