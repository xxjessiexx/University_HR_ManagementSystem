using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace UNI
{
    public partial class HRDeductions : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Only HR can access
                if (Session["HRID"] == null)
                {
                    Response.Redirect("LogIn.aspx");
                    return;
                }
            }
        }

        protected void btnBackHome_Click(object sender, EventArgs e)
        {
            Response.Redirect("HRHome.aspx");
        }

        private int GetEmpIdFromTextBox()
        {
            int empId;
            if (!int.TryParse(txtEmpID.Text, out empId))
            {
                lblMessage.CssClass = "error";
                lblMessage.Text = "❌ Employee ID must be a number.";
                return -1;
            }
            return empId;
        }

        protected void btnMissingHours_Click(object sender, EventArgs e)
        {
            int empId = GetEmpIdFromTextBox();
            if (empId == -1) return;

            string connStr = ConfigurationManager
                .ConnectionStrings["GUCera"]
                .ToString();

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    // 1) Call SP
                    SqlCommand cmd = new SqlCommand("Deduction_hours", conn);
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@employee_ID", empId);
                    cmd.ExecuteNonQuery();

                    // 2) Check if a deduction was created this month
                    SqlCommand check = new SqlCommand(@"
                        SELECT COUNT(*) FROM Deduction
                        WHERE emp_ID = @id
                          AND type = 'missing_hours'
                          AND MONTH([date]) = MONTH(GETDATE())
                          AND YEAR([date]) = YEAR(GETDATE());
                    ", conn);
                    check.Parameters.AddWithValue("@id", empId);

                    int count = (int)check.ExecuteScalar();

                    if (count > 0)
                    {
                        lblMessage.CssClass = "success";
                        lblMessage.Text =
                            $"✔ Missing-hours deduction calculated for Employee {empId}. " +
                            $"Check the Deduction table for details.";
                    }
                    else
                    {
                        lblMessage.CssClass = "error";
                        lblMessage.Text =
                            "ℹ No missing-hours deduction created. " +
                            "Reason: no missing hours found this month.";
                    }
                }
            }
            catch (Exception ex)
            {
                lblMessage.CssClass = "error";
                lblMessage.Text =
                    "❌ Error while adding missing-hours deduction: " + ex.Message;
            }
        }

        protected void btnMissingDays_Click(object sender, EventArgs e)
        {
            int empId = GetEmpIdFromTextBox();
            if (empId == -1) return;

            string connStr = ConfigurationManager
                .ConnectionStrings["GUCera"]
                .ToString();

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    SqlCommand cmd = new SqlCommand("Deduction_days", conn);
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@employee_ID", empId);
                    cmd.ExecuteNonQuery();

                    SqlCommand check = new SqlCommand(@"
                        SELECT COUNT(*) FROM Deduction
                        WHERE emp_ID = @id
                          AND type = 'missing_days'
                          AND MONTH([date]) = MONTH(GETDATE())
                          AND YEAR([date]) = YEAR(GETDATE());
                    ", conn);
                    check.Parameters.AddWithValue("@id", empId);

                    int count = (int)check.ExecuteScalar();

                    if (count > 0)
                    {
                        lblMessage.CssClass = "success";
                        lblMessage.Text =
                            $"✔ Missing-days deductions created for Employee {empId}.";
                    }
                    else
                    {
                        lblMessage.CssClass = "error";
                        lblMessage.Text =
                            "ℹ No missing-days deductions created. " +
                            "Reason: no absent days found this month.";
                    }
                }
            }
            catch (Exception ex)
            {
                lblMessage.CssClass = "error";
                lblMessage.Text =
                    "❌ Error while adding missing-days deduction: " + ex.Message;
            }
        }

        protected void btnUnpaidDeduction_Click(object sender, EventArgs e)
        {
            int empId = GetEmpIdFromTextBox();
            if (empId == -1) return;

            string connStr = ConfigurationManager
                .ConnectionStrings["GUCera"]
                .ToString();

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    SqlCommand cmd = new SqlCommand("Deduction_unpaid", conn);
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@employee_ID", empId);
                    cmd.ExecuteNonQuery();

                    SqlCommand check = new SqlCommand(@"
                        SELECT COUNT(*) FROM Deduction
                        WHERE emp_ID = @id
                          AND type = 'unpaid'
                          AND MONTH([date]) = MONTH(GETDATE())
                          AND YEAR([date]) = YEAR(GETDATE());
                    ", conn);
                    check.Parameters.AddWithValue("@id", empId);

                    int count = (int)check.ExecuteScalar();

                    if (count > 0)
                    {
                        lblMessage.CssClass = "success";
                        lblMessage.Text =
                            $"✔ Unpaid-leave deductions added for Employee {empId}.";
                    }
                    else
                    {
                        lblMessage.CssClass = "error";
                        lblMessage.Text =
                            "ℹ No unpaid-leave deductions created. " +
                            "Reason: no approved unpaid leave found for this month.";
                    }
                }
            }
            catch (Exception ex)
            {
                lblMessage.CssClass = "error";
                lblMessage.Text =
                    "❌ Error while adding unpaid-leave deduction: " + ex.Message;
            }
        }
    }
}
