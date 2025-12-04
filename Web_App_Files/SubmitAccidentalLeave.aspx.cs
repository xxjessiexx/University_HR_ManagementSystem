using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Runtime.InteropServices.ComTypes;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace UNI
{
    public partial class SubmitAccidentalLeave : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void Submit_accidental(object sender, EventArgs e)
        {
            mssg.Visible = false;
            SqlConnection conn = null;

            try
            {
                //empty inputs 
                if (string.IsNullOrWhiteSpace(empId.Text) ||
                    string.IsNullOrWhiteSpace(StartDate.Text) ||
                    string.IsNullOrWhiteSpace(EndDate.Text))
                {
                    Showmessage("All fields are required,please fill all.");
                    return;
                }

                int employeeID;
                DateTime startDate, endDate;

                //employee ID error
                if (!int.TryParse(empId.Text, out employeeID))
                {
                    Showmessage("Employee id must be a number.");
                    return;
                }

                //dates error
                if (!DateTime.TryParse(StartDate.Text, out startDate) ||
                    !DateTime.TryParse(EndDate.Text, out endDate))
                {
                    Showmessage("Invalid dates");
                    return;
                }

                if (endDate < startDate)
                {
                    Showmessage("End date cannot be earlier than start date.");
                    return;
                }

                String connStr = WebConfigurationManager.ConnectionStrings["GUCera"].ToString();
                conn = new SqlConnection(connStr);

                int id = Int16.Parse(empId.Text);
                DateTime sdate = DateTime.Parse(StartDate.Text);
                DateTime edate = DateTime.Parse(EndDate.Text);


                SqlCommand submitaccidentalproc = new SqlCommand("Submit_accidental", conn);
                submitaccidentalproc.CommandType = CommandType.StoredProcedure;

                submitaccidentalproc.Parameters.Add(new SqlParameter("@employee_ID", id));
                submitaccidentalproc.Parameters.Add(new SqlParameter("@start_date", sdate));
                submitaccidentalproc.Parameters.Add(new SqlParameter("@end_date", edate));


                conn.Open();
                submitaccidentalproc.ExecuteNonQuery();

                Showmessage("Your accidental leave request has been submitted successfully.");
            }
            catch (SqlException)
            {
                Showmessage("Database error occured.The employee ID entered does not exist in the database. please refer back to adminstrator.");
            }
            catch (Exception)
            {
                Showmessage("error occurred. try again");
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