using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace UNI
{
    public partial class SubmitCompensationLeave : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void Submit_compensation(object sender, EventArgs e)
        {
            mssg.Visible = false;
            SqlConnection conn = null;

            try
            {
                // empty inputs
                if (string.IsNullOrWhiteSpace(empId.Text) ||
                    string.IsNullOrWhiteSpace(comp_date.Text) ||
                    string.IsNullOrWhiteSpace(reason.Text) ||
                    string.IsNullOrWhiteSpace(original_date.Text) ||
                    string.IsNullOrWhiteSpace(replace_ID.Text))
                {
                    Showmessage("All fields are required,please fill all.");
                    return;
                }

                // inputs  1.not int
                if (!int.TryParse(empId.Text, out int employeeID))
                {
                    Showmessage("Employee ID must be a number.");
                    return;
                }

                if (!DateTime.TryParse(comp_date.Text, out DateTime compensationDate) ||
                    !DateTime.TryParse(original_date.Text, out DateTime originalDate))
                {
                    Showmessage("Invalid dates. Try again");
                    return;
                }

                if (!int.TryParse(replace_ID.Text, out int replacementID))
                {
                    Showmessage("Replacement Employee ID must be a number.");
                    return;
                }

                string connStr = WebConfigurationManager.ConnectionStrings["GUCera"].ToString();
                conn = new SqlConnection(connStr);

                SqlCommand submitcompproc = new SqlCommand("Submit_compensation", conn);
                submitcompproc.CommandType = CommandType.StoredProcedure;

                int id = Int16.Parse(empId.Text);
                DateTime compdate = DateTime.Parse(comp_date.Text);
                DateTime originaldate = DateTime.Parse(original_date.Text);
                int replacement_id = Int16.Parse(replace_ID.Text);
                string reasonreq = reason.Text;

                submitcompproc.Parameters.Add(new SqlParameter("@employee_ID", id));
                submitcompproc.Parameters.Add(new SqlParameter("@compensation_date", compdate));
                submitcompproc.Parameters.Add(new SqlParameter("@reason", reasonreq));
                submitcompproc.Parameters.Add(new SqlParameter("@date_of_original_workday", originaldate));
                submitcompproc.Parameters.Add(new SqlParameter("@rep_emp_id", replacement_id));

                conn.Open();
                submitcompproc.ExecuteNonQuery();

                // success mssg
                Showmessage("Your compensation leave request has been submitted successfully.");
            }

            catch (SqlException)
            {
                Showmessage("Database error occured.The employee ID entered does not exist in the database. please refer back to adminstrator.");
            }
            catch (Exception)
            {
                Showmessage("an error occurred. Please try again.");
            }
            finally
            {
                // close connection
                if (conn != null && conn.State == System.Data.ConnectionState.Open)
                {
                    conn.Close();
                }
            }

        }
        private void Showmessage(string message)
        {
            mssg.Text = message;
            mssg.Visible = true;
        }
    }
}