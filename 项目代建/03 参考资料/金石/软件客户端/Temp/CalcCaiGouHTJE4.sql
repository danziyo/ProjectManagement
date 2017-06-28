Create PROCEDURE [dbo].[CalcCaiGouHTJE4]
@htbh Varchar(100),
@zxfssj1 datetime,
@zxfssj2 datetime,
@zxtxsj1 datetime,
@zxtxsj2 datetime,
@fkfssj1 datetime,
@fkfssj2 datetime,
@fktxsj1 datetime,
@fktxsj2 datetime,
@fpje Float output,
@zxje Float output,
@fkje Float output,
@FaKuanje Float output
 
As
BEGIN
  Declare @sql Varchar(1000)
  Declare @ZXDateSql Varchar(1000)
  Declare @FKDateSql Varchar(1000)    
  Set @ZXDateSql=''
  Set @FKDateSql=''
  IF IsNULL(@zxfssj1,'')<>'' 
  Begin
    Set @ZXDateSql=@ZXDateSql+' And �������� >='''+cast(@zxfssj1 as varchar(80))+''''
  End
  IF IsNULL(@zxfssj2,'')<>'' 
  Begin
    Set @ZXDateSql=@ZXDateSql+' And �������� <='''+cast(@zxfssj2 as varchar(80))+''''
  End
  IF IsNULL(@zxtxsj1,'')<>'' 
  Begin
    Set @ZXDateSql=@ZXDateSql+' And ��д���� >='''+cast(@zxtxsj1 as varchar(80))+'''' 
  End
  IF IsNULL(@zxtxsj2,'')<>'' 
  Begin
    Set @ZXDateSql=@ZXDateSql+' And ��д���� <='''+cast(@zxtxsj2 as varchar(80))+''''
  End

  IF IsNULL(@fkfssj1,'')<>'' 
  Begin
    Set @FKDateSql=@FKDateSql+' And �������� >='''+cast(@fkfssj1 as varchar(80))+'''' 
  End
  IF IsNULL(@fkfssj2,'')<>'' 
  Begin
    Set @FKDateSql=@FKDateSql+' And �������� <='''+cast(@fkfssj2 as varchar(80))+'''' 
  End
  IF IsNULL(@fktxsj1,'')<>'' 
  Begin
    Set @FKDateSql=@FKDateSql+' And ��д���� >='''+cast(@fktxsj1 as varchar(80))+''''   
  End
  IF IsNULL(@fktxsj2,'')<>'' 
  Begin
    Set @FKDateSql=@FKDateSql+' And ��д���� <='''+cast(@fktxsj2 as varchar(80))+'''' 
  End  


  Set @sql='Declare cur1 Cursor Global For Select Sum(��Ӧ���) As FPJE From ��Ʊ�ӱ� where ����=0 And (1=2 '
  Set @sql=@sql+' or (��Ӧ��������=''���ϲɹ���'' And Exists (Select ��Ӧ���� From �������˱� where �������˱�.��Ӧ����=��Ʊ�ӱ�.��Ʊ��Ӧ���� And ����=0 And ��������=''���ϲɹ���'' And ��ͬ���='''+@htbh+''' ) )'
  Set @sql=@sql+' or (��Ӧ��������=''�豸�ɹ���'' And Exists (Select ��Ӧ���� From �̶��豸���˱� where �̶��豸���˱�.��Ӧ����=��Ʊ�ӱ�.��Ʊ��Ӧ���� And ����=0 And ��������=''�豸�ɹ���'' And ��ͬ���='''+@htbh+''' ) )'
  Set @Sql=@Sql+' ) '
  Exec(@Sql)
  Open cur1
  Fetch Next From cur1 into @fpje
  Close cur1
  deallocate cur1 
  Set @fpje=ISNULL(@fpje ,0)

  Declare @kcissh bit
  Set @kcissh=0                                          
  select @kcissh=���� From ϵͳȫ�����ñ� where ��������='���ϵ����е���ֻ����˺�ſɲ�����������'

  Set @Sql='Declare cur1 Cursor Global For Select Sum(���*(�ⷿ����+��Ŀ����)) As LjJE From ������ϸ�� where ��ͬ���='''+@HTBH+''' And ����=0 And (��������=''���ϲɹ���'' or ��������=''�����˻���'' )'
  IF @kcissh=1 Begin Set @Sql=@Sql+' And ��˷�=1 ' End
  Set @Sql=@Sql+@ZXDateSql
  Exec(@Sql)
  Open cur1
  Fetch Next From cur1 into @zxje
  Close cur1
  deallocate cur1 
  Set @zxje=ISNULL(@zxje ,0) 

  Declare @gdzcje Float
  Set @Sql='Declare cur1 Cursor Global For Select Sum(���) As LjJE From �̶��豸��ϸ�� where ��ͬ���='''+@HTBH+''' And ����=0 And ��������=''�豸�ɹ���''' 
  Set @Sql=@Sql+@ZXDateSql
  Exec(@Sql)
  Open cur1
  Fetch Next From cur1 into @gdzcje
  Close cur1
  deallocate cur1 
  Set @gdzcje=ISNULL(@gdzcje ,0)  
  Set @zxje=@zxje+@gdzcje

  Set @Sql='Declare cur1 Cursor Global For Select Sum( Case When ��������=''���'' then ��� Else -��� End ) As LjJE From �ո������˱� where ��ͬ���='''+@HTBH+''' And ����=0 And  ִ�к�ͬ=''�ɹ���ͬ'' ' 
  Set @Sql=@Sql+@FKDateSql 
  Exec(@Sql)
  Open cur1
  Fetch Next From cur1 into @fkje
  Close cur1
  deallocate cur1 
  Set @fkje=ISNULL(@fkje ,0)  
  
  
  Set @Sql='Declare cur1 Cursor Global For Select Sum(������) As LjJE From ������ where ��ͬ���='''+@HTBH+''' And ����=0 ' 
  Set @Sql=@Sql+@ZXDateSql
  Exec(@Sql)
  Open cur1
  Fetch Next From cur1 into @FaKuanje
  Close cur1
  deallocate cur1 
  Set @FaKuanje=ISNULL(@FaKuanje ,0)   
  
END   
