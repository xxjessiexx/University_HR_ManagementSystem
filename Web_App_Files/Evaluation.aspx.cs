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
    public partial class Evaluation : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void Evaluate(object sender, EventArgs e)
        {
            mssg.Visible = false;
            SqlConnection conn = null;

            try
            {
                // empty inputs
                if (string.IsNullOrWhiteSpace(empId.Text) ||
                    string.IsNullOrWhiteSpace(rate.Text) ||
                    string.IsNullOrWhiteSpace(sem.Text) ||
                    string.IsNullOrWhiteSpace(comments.Text))
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

                if (!int.TryParse(rate.Text, out int rates))
                {
                    Showmessage("Rating must be a number.");
                    return;
                }

                string connStr = WebConfigurationManager.ConnectionStrings["GUCera"].ToString();
                conn = new SqlConnection(connStr);

                SqlCommand evaluateproc = new SqlCommand("Dean_andHR_Evaluation", conn);
                evaluateproc.CommandType = CommandType.StoredProcedure;

                int id = Int16.Parse(empId.Text);
                int therating = Int16.Parse(rate.Text);
                string semester = sem.Text;
                string comment = comments.Text;

                evaluateproc.Parameters.Add(new SqlParameter("@employee_ID", id));
                evaluateproc.Parameters.Add(new SqlParameter("@rating", therating));
                evaluateproc.Parameters.Add(new SqlParameter("@semester", semester));
                evaluateproc.Parameters.Add(new SqlParameter("@comment", comment));

                conn.Open();
                evaluateproc.ExecuteNonQuery();

                // success mssg
                Showmessage("Employee evaluated successfully.");
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