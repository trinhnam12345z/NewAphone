using Aphone.DAL.Interface;
using Aphone.Domain.Response.Category;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Threading.Tasks;

namespace Aphone.DAL
{
    public class CategoryRepository : BaseRepository, ICategoryRepository
    {
        public async Task<IEnumerable<Category>> Gets()
        {
            return await SqlMapper.QueryAsync<Category>(cnn: connect,
                                                sql: "sp_GetCategory",
                                                commandType: CommandType.StoredProcedure);
        }
    }
}
