using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace UNI
{
    public partial class HRPayroll : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Ensure HR is logged in
                if (Session["HRID"] == null)
                {
                    Response.Redirect("LogIn.aspx");
                    return;
                }
            }
        }

        protected void btnGenerate_Click(object sender, EventArgs e)
        {
            // reset message
            lblMessage.Text = string.Empty;
            lblMessage.CssClass = string.Empty;

            // 1) Validate Employee ID
            int empId;
            if (!int.TryParse(txtEmpID.Text, out empId))
            {
                lblMessage.CssClass = "error";
                lblMessage.Text = "❌ Employee ID must be a number.";
                return;
            }

            // 2) Validate dates
            DateTime fromDate, toDate;
            if (!DateTime.TryParse(txtFromDate.Text, out fromDate) ||
                !DateTime.TryParse(txtToDate.Text, out toDate))
            {
                lblMessage.CssClass = "error";
                lblMessage.Text = "❌ Please enter valid dates (From and To).";
                return;
            }

            string connStr = ConfigurationManager
                                .ConnectionStrings["GUCera"]
                                .ConnectionString;

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    // 3) Call Add_Payroll stored procedure
                    using (SqlCommand cmd = new SqlCommand("Add_Payroll", conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@employee_ID", empId);
                        cmd.Parameters.AddWithValue("@from", fromDate);
                        cmd.Parameters.AddWithValue("@to", toDate);

                        cmd.ExecuteNonQuery();
                    }

                    // 4) Fetch the latest payroll row for this employee
                    using (SqlCommand getPayroll = new SqlCommand(@"
                        SELECT TOP 1 payment_date,
                                       final_salary_amount,
                                       bonus_amount,
                                       deductions_amount,
                                       comments
                        FROM Payroll
                        WHERE emp_ID = @id
                        ORDER BY payment_date DESC, ID DESC;", conn))
                    {
                        getPayroll.Parameters.AddWithValue("@id", empId);

                        using (SqlDataReader rdr = getPayroll.ExecuteReader())
                        {
                            if (!rdr.Read())
                            {
                                lblMessage.CssClass = "error";
                                lblMessage.Text = "❌ No payroll record found after generation. Please verify the employee and period.";
                                return;
                            }

                            DateTime payDate = rdr.GetDateTime(0);
                            decimal finalSalary = rdr.GetDecimal(1);
                            decimal bonus = rdr.GetDecimal(2);
                            decimal deductions = rdr.GetDecimal(3);
                            string comments = rdr.IsDBNull(4) ? "" : rdr.GetString(4);

                            lblMessage.CssClass = "success";
                            lblMessage.Text =
                                $"✅ Payroll generated for Employee {empId} on {payDate:yyyy-MM-dd}.<br/>" +
                                $"Final Salary: {finalSalary}<br/>" +
                                $"Bonus: {bonus}<br/>" +
                                $"Deductions: {deductions}<br/>" +
                                $"Comments: {comments}";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lblMessage.CssClass = "error";
                lblMessage.Text = "❌ Error while generating payroll: " + ex.Message;
            }
        }
    }
}
