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
    public partial class SubmitMedicalLeave : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void Submit_medical(object sender, EventArgs e)
        {
            mssg.Visible = false;
            SqlConnection conn = null;

            try
            {
                // empty inputs
                if (string.IsNullOrWhiteSpace(empId.Text) ||
                    string.IsNullOrWhiteSpace(sdate.Text) ||
                    string.IsNullOrWhiteSpace(edate.Text) ||
                    string.IsNullOrWhiteSpace(doc_des.Text) ||
                    string.IsNullOrWhiteSpace(file_name.Text))
                {
                    Showmessage("All fields are required, please fill all.");
                    return;
                }

                // check employee ID
                if (!int.TryParse(empId.Text, out int employeeID))
                {
                    Showmessage("Employee ID must be a number.");
                    return;
                }

                // check dates
                if (!DateTime.TryParse(sdate.Text, out DateTime startDate) ||
                    !DateTime.TryParse(edate.Text, out DateTime endDate))
                {
                    Showmessage("invalid dates. please enter valid dates.");
                    return;
                }

                if (endDate < startDate)
                {
                    Showmessage("invalid dates.");
                    return;
                }

                string connStr = WebConfigurationManager.ConnectionStrings["GUCera"].ToString();
                conn = new SqlConnection(connStr);

                SqlCommand submitmedicalproc = new SqlCommand("Submit_medical", conn);
                submitmedicalproc.CommandType = CommandType.StoredProcedure;

                int employeeId = Int16.Parse(empId.Text);
                DateTime startdate = DateTime.Parse(sdate.Text);
                DateTime enddate = DateTime.Parse(edate.Text);
                string disability = dis_details.Text;
                string doc = doc_des.Text;
                string filename = file_name.Text;
                int insuranceStatus = int.Parse(insurance_stat.SelectedValue);
                string leavetype = type.SelectedValue;


                submitmedicalproc.Parameters.Add(new SqlParameter("@employee_ID", employeeId));
                submitmedicalproc.Parameters.Add(new SqlParameter("@start_date", startdate));
                submitmedicalproc.Parameters.Add(new SqlParameter("@end_date", enddate));
                submitmedicalproc.Parameters.Add(new SqlParameter("@medical_type", leavetype));
                submitmedicalproc.Parameters.Add(new SqlParameter("@insurance_status", insuranceStatus));
                submitmedicalproc.Parameters.Add(new SqlParameter("@disability_details", disability));
                submitmedicalproc.Parameters.Add(new SqlParameter("@document_description", doc));
                submitmedicalproc.Parameters.Add(new SqlParameter("@file_name", filename));

                conn.Open();
                submitmedicalproc.ExecuteNonQuery();

                Showmessage("Your medical leave request has been submitted successfully.");
            }
            catch (SqlException ex)
            {

                Showmessage("Database error occured.The employee ID entered does not exist in the database. please refer back to adminstrator.");
            }
            catch (Exception)
            {
                Showmessage("error occurred. please try again.");
            }
            finally
            {
                if (conn != null && conn.State == ConnectionState.Open)
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